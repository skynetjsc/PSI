//
//  RxAlamofireClient.swift
//  qldt2-utility
//
//  Created by Mac on 9/5/18.
//  Copyright © 2018 NhatQuang. All rights reserved.
//

import Foundation
import Alamofire
import RxAlamofire
import RxCocoa
import RxSwift
import SwiftyJSON

enum APIError: Error {
    case invalidURL(url: String)
    case invalidResponseData(data: Any)
    case error(responseCode: Int, data: Any)
}

enum ResponseError: Error {
    case noStatusCode
    case invalidData(data: Any)
    
    case unknown(statusCode: Int)
    case notModified // 304
    case invalidRequest // 400
    case unauthorized // 401
    case accessDenied // 403
    case notFound // 404
    case methodNotAllowed // 405
    case validate // 422
    case serverError // 500
    case badGateway // 502
    case serviceUnavailable // 503
    case gatewayTimeout // 504
}

enum APIErrorCode: Int {
    case ResponseSuccess = 201
    case AuthtokenInvalid = 401
    case NotFound = 404
    case ServerInternalError = 500
    case Unknown = 0
}

public let kPageSize = 20
public let kCodeSuccess = 200

class RxAlamofireClient: NSObject {

    static let shared = RxAlamofireClient()
    
    var sessionManager: SessionManager!
    //var baseURL: String!
    var headers: [String : Any] = [
        //"Content-Type":"application/json; charset=utf-8",
        "Accept":"application/json"
    ]
    var reachabilityService: DefaultReachabilityService!
    var disposeBag = DisposeBag()
    
    fileprivate override init() {
        super.init()
        
        //self.baseURL = kBaseURL
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = kTimeoutRequest
        sessionManager = Alamofire.SessionManager(configuration: configuration)
        
        // setup reachability
        self.reachabilityService = try! DefaultReachabilityService() // try! is only for simplicity sake
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.reachabilityService.reachability
                .map { $0.reachable }
                .subscribe(onNext: { (reachable) in
                    //print(reachable)
                    if !reachable {
                        AppMessagesManager.shared.showNoInternetConnection()
                    } else {
                        AppMessagesManager.shared.hideNoInternetConnection()
                    }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
                .disposed(by: self.disposeBag)
        }
    }
}

// MARK: - API Call
extension RxAlamofireClient {
    
    func request(method: HTTPMethod,
                 endpoint: String,
                 parameters: [String : Any]? = nil,
                 encoding: ParameterEncoding = URLEncoding.default,
                 headers: [String : Any]? = nil) -> Observable<Any> {
        print("\(method.rawValue) : \(endpoint)")
        var aParameters: [String: Any] = parameters ?? [String: Any]()
        aParameters["device_type"] = 0 // ios: 0; android: 1
        aParameters["os_version"] = PUtilities.getOSVersion()
        aParameters["lang_code"] = PUtilities.getCurrentLanguageCode()
        if let deviceToken = userDefaults.string(forKey: kDeviceToken) {
            aParameters["device_token"] = deviceToken
        }
        //aParameters["device_id"] = PAboutApp.IDFA
        
        let aHeader: [String : Any] = headers ?? self.headers
        return self.sessionManager.rx
            .request(method, endpoint, parameters: aParameters, encoding: encoding, headers: aHeader as? [String : String])
            .flatMap { dataRequest -> Observable<DataResponse<Any>> in
                dataRequest
                    .rx.responseJSON()
            }
            .map { (dataResponse) -> Any in
                return try self.process(dataResponse)
            }
    }
    
    // link refer mimeType: https://gist.github.com/ngs/918b07f448977789cf69
    // mimeType: String = "image/png" | "video/quicktime" | "audio/x-m4a"
    func upload(endpoint: String,
                parameters: [String : Any]? = nil,
                filesData: [(key: String, value: Data, fileName: String, mimeType: String)]) -> Observable<Any> {
        return Observable.create({ observer in
            self.sessionManager.upload(multipartFormData: { (multipartFormData) in
                // image data or file data
                for file in filesData {
                    multipartFormData.append(file.value, withName: file.key, fileName: file.fileName, mimeType: file.mimeType)
                }
                // Other params
                for (key, value) in parameters! {
                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
                }
            }, to: endpoint, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.uploadProgress(closure: { (progress) in
                        print("Total byte writen: \(progress.completedUnitCount)")
                    })
                    
                    upload.responseJSON { response in
                        /*
                         print(response.request!)  // original URL request
                         print(response.response!) // URL response
                         print(response.data!)     // server data
                         print(response.result)   // result of response serialization
                         */
                        if let value = response.result.value {
                            observer.onNext(value)
                            observer.onCompleted()
                        } else {
                            observer.onError(response.result.error!)
                        }
                    }
                    
                    break
                case .failure(let encodingError):
                    observer.onError(encodingError)
                    break
                }
            })
            
            return Disposables.create()
        })
    }
    
    private func process(_ response: DataResponse<Any>) throws -> Any {
        let error: Error
        switch response.result {
        case .success(let value):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 200:
                    //return value
                    
                    let json = JSON(value)
                    // check authen token
                    if json["errorId"].intValue == APIErrorCode.AuthtokenInvalid.rawValue {
                        showAuthenTokenAlert(message: json["message"].string ?? "Tài khoản của bạn đã đăng nhập ở thiết bị khác. Vui lòng đăng nhập lại".localized())
                        error = ResponseError.unauthorized
                    } else {
                        return value
                    }
                case 304:
                    error = ResponseError.notModified
                case 400:
                    error = ResponseError.invalidRequest
                case 401:
                    error = ResponseError.unauthorized
                case 403:
                    error = ResponseError.accessDenied
                case 404:
                    error = ResponseError.notFound
                case 405:
                    error = ResponseError.methodNotAllowed
                case 422:
                    error = ResponseError.validate
                case 500:
                    error = ResponseError.serverError
                case 502:
                    error = ResponseError.badGateway
                case 503:
                    error = ResponseError.serviceUnavailable
                case 504:
                    error = ResponseError.gatewayTimeout
                default:
                    error = ResponseError.unknown(statusCode: statusCode)
                }
            } else {
                error = ResponseError.noStatusCode
            }
            //print(value)
        case .failure(let e):
            error = e
        }
        throw error
    }
    
    private func showAuthenTokenAlert(message: String) {
        _ = EZAlertController.alert(PAboutApp.appName, message: message, acceptMessage: LANGTEXT(key: "OK"), acceptBlock: {
            PAppManager.shared.accessToken = nil
            PAppManager.shared.currentUser = nil
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                //appDelegate.showLogin()
            }
        })
    }
}









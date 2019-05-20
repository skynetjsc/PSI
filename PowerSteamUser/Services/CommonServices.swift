//
//  CommonServices.swift
//  Receigo
//
//  Created by Mac on 11/12/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift

class CommonServices {
    
    
//    /// upload photo
//    ///
//    /// - Returns: Observable object
//    func uploadPhoto(params: [String : Any]?, imageData: Data) -> Observable<PImageModel> {
//        //RxAlamofireClient.shared.headers["AuthToken"] = userDefaults.string(forKey: kAuthToken) ?? ""
//        return RxAlamofireClient.shared.upload(endpoint: EndpointAPI.uploadImage, parameters: params, filesData: [(key: "image", value: imageData)])
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> PImageModel in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return PImageModel(json: json["data"])
//                    } else {
//                        throw APIError.error(responseCode: json["code"].intValue, data: json["message"].stringValue)
//                    }
//                } else {
//                    throw APIError.invalidResponseData(data: data)
//                }
//            })
//            .share(replay: 1)
//    }
    
//
//    /// get help list
//    ///
//    /// - Returns: Observable object
//    func getHelpList() -> Observable<[PHelpModel]> {
//        RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
//        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.helpList)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> [PHelpModel] in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return json["data"].arrayValue.map { PHelpModel(json: $0) }
//                    } else {
//                        throw APIError.error(responseCode: json["code"].intValue, data: json["message"].stringValue)
//                    }
//                } else {
//                    throw APIError.invalidResponseData(data: data)
//                }
//            })
//            .share(replay: 1)
//    }
//
    
    func getTermsAgreement(agreementType: AgreementType) -> Observable<PTermsAgreementModel> {
        //RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
        var endpoint = ""
        switch agreementType {
        case .privacy:
            endpoint = EndpointAPI.privacy
        default:
            endpoint = EndpointAPI.term
        }
        return RxAlamofireClient.shared.request(method: .get, endpoint: endpoint)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PTermsAgreementModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess && json["data"].dictionary != nil {
                        return PTermsAgreementModel(json: json["data"])
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    func addCar(params: [String : Any]) -> Observable<String> {
        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.addCar, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> String in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return json["message"].stringValue
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
}

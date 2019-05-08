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
//    /// get terms of use
//    ///
//    /// - Returns: Observable object
//    func getTermsOfUse() -> Observable<String> {
//        RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
//        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.termsOfUse)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> String in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return json["data"].stringValue
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
//    func getTermsAgreement() -> Observable<String> {
//        RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
//        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.termsAgreement)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> String in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return json["data"].stringValue
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
//    /// get policy
//    ///
//    /// - Returns: Observable object
//    func getPolicy() -> Observable<String> {
//        //RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
//        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.policy)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> String in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return json["data"].stringValue
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
//    /// get user guide
//    ///
//    /// - Returns: Observable object
//    func getUserGuide() -> Observable<String> {
//        RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
//        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.userGuide)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> String in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return json["data"].stringValue
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
//    /// get transfer Schedule
//    ///
//    /// - Returns: Observable object
//    func getTransferSchedule() -> Observable<String> {
//        RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
//        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.transferSchedule)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> String in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return json["data"].stringValue
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
//    func getArticleDetail(urlString: String) -> Observable<String> {
//        RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
//        return RxAlamofireClient.shared.request(method: .get, endpoint: urlString)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> String in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return json["data"].stringValue
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
//    /// contact
//    ///
//    /// - Parameter params: dictionary object
//    /// - Returns: Observable object
//    func contact(params: [String: Any]) -> Observable<String> {
//        RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
//        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.contact, parameters: params)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> String in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["success"].boolValue
//                    if result {
//                        return json["message"].stringValue
//                    } else {
//                        throw APIError.error(responseCode: json["code"].intValue, data: json["message"].stringValue)
//                    }
//                } else {
//                    throw APIError.invalidResponseData(data: data)
//                }
//            })
//            .share(replay: 1)
//    }
}

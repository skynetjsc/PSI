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
    
    /// get terms agreement
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
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
    
    /// add car
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
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
    
    /// get promotion list
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func getPromotionList(params: [String: Any]) -> Observable<[PPromotionModel]> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.promotion, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> [PPromotionModel] in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return json["data"].arrayValue.map { PPromotionModel(json: $0) }
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// get promotion detail
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func getPromotionDetail(params: [String: Any]) -> Observable<PPromotionModel> {
        //RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.promotionDetail, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PPromotionModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess && json["data"].dictionary != nil {
                        return PPromotionModel(json: json["data"])
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// get feedback list
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func getFeedbackList(params: [String: Any]) -> Observable<[PFeedbackModel]> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.listFeedback, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> [PFeedbackModel] in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return json["data"].arrayValue.map { PFeedbackModel(json: $0) }
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// get feedback detail
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func getFeedbackDetail(params: [String: Any]) -> Observable<PFeedbackModel> {
        //RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
        
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.feedbackDetail, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PFeedbackModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess && json["data"].dictionary != nil {
                        return PFeedbackModel(json: json["data"])
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// send new feedback
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func sendFeedback(params: [String: Any]) -> Observable<String> {
        //RxAlamofireClient.shared.headers["Authorization"] = "Bearer " + (userDefaults.string(forKey: kAuthToken) ?? "")
        
        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.sendFeedback, parameters: params)
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
    
    /// send new feedback
    ///
    /// - Returns: Observable object
    func sendFeedback(params: [String : Any]?, filesData: [(key: String, value: Data, fileName: String, mimeType: String)]) -> Observable<String> {
        return RxAlamofireClient.shared.upload(endpoint: EndpointAPI.sendFeedback, parameters: params, filesData: filesData)
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
    
    /// get location list
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func getLocationList(params: [String: Any]) -> Observable<[PLocationModel]> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.location, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> [PLocationModel] in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return json["data"].arrayValue.map { PLocationModel(json: $0) }
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

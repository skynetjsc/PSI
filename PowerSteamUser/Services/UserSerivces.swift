//
//  UserSerivces.swift
//  Receigo
//
//  Created by Mac on 11/12/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift

class UserServices {
    
    /// verifyCode
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func verifyCode(params: [String: Any]) -> Observable<Int> {
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.verifyCode, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> Int in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return json["data"].intValue
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// register user
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func register(params: [String: Any]) -> Observable<PUserModel> {
        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.register, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PUserModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess && json["data"].dictionary != nil {
                        return PUserModel(json: json["data"])
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// login
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func login(params: [String: Any]) -> Observable<PUserModel> {
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.login, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PUserModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess && json["data"].dictionary != nil {
                        return PUserModel(json: json["data"])
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// update setting
    ///
    /// - Returns: Observable object
    func logout(params: [String: Any]) -> Observable<String> {
        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.logout, parameters: params)
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
    
    /// get infor
    ///
    /// - Parameter dictionary object
    /// - Returns: Observable object
    func getInfo(params: [String: Any]) -> Observable<PUserModel> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.getInfo, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PUserModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess && json["data"].dictionary != nil {
                        return PUserModel(json: json["data"])
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// forgetPassword
    ///
    /// - Parameter dictionary object
    /// - Returns: Observable object
    func forgetPassword(params: [String: Any]) -> Observable<String> {
        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.forgetPassword, parameters: params)
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
    
    /// get user infor
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func getProfile(params: [String: Any]) -> Observable<PUserModel> {
        RxAlamofireClient.shared.headers["accessToken"] = userDefaults.string(forKey: kAuthToken) ?? ""
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.getInfo, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PUserModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["code"].intValue
                    if result == kCodeSuccess {
                        return PUserModel(json: json["data"])
                    } else {
                        throw APIError.error(responseCode: json["code"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// update avatar
    ///
    /// - Returns: Observable object
    func updateAvatar(params: [String : Any]?, filesData: [(key: String, value: Data, fileName: String, mimeType: String)]) -> Observable<(url: String, message: String)> {
        return RxAlamofireClient.shared.upload(endpoint: EndpointAPI.updateAvatar, parameters: params, filesData: filesData)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> (url: String, message: String) in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return (url: json["data"].stringValue, message: json["message"].stringValue)
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// update device id
    ///
    /// - Returns: Observable object
    func postDevice(param: [String: Any]) -> Observable<[String: JSON]> {
        RxAlamofireClient.shared.headers["accessToken"] = userDefaults.string(forKey: kAuthToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.registerDevice, parameters: param)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> [String: JSON] in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["code"].intValue
                    if result == kCodeSuccess {
                        return json["data"].dictionaryValue
                    } else {
                        throw APIError.error(responseCode: result, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    

//
//    /// get list task
//    ///
//    /// - Parameter userID: userID need get profile
//    /// - Returns: Observable object
//    func getListNotification(page: Int, params: [String: Any]) -> Observable<(list: [PNotificationModel], unreadCount: Int)> {
//        RxAlamofireClient.shared.headers["accessToken"] = userDefaults.string(forKey: kAuthToken) ?? ""
//        let endpoint = String(format: EndpointAPI.listNotification, page, kPageSize)
//        return RxAlamofireClient.shared.request(method: .get, endpoint: endpoint, parameters: params)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> (list: [PNotificationModel], unreadCount: Int) in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["code"].intValue
//                    if result == kCodeSuccess {
//                        return (list: json["data"]["list"].arrayValue.map { PNotificationModel(json: $0) }, unreadCount: json["data"]["unread_count"].intValue)
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
//    func readNotification(notificationID: Int, params: [String: Any]) -> Observable<Int> {
//        RxAlamofireClient.shared.headers["accessToken"] = userDefaults.string(forKey: kAuthToken) ?? ""
//        let endpoint = String(format: EndpointAPI.readNotify, notificationID)
//        return RxAlamofireClient.shared.request(method: .get, endpoint: endpoint, parameters: params)
//            .observeOn(MainScheduler.instance)
//            .map({ (data) -> Int in
//                if let jsonFormat = data as? [String: Any] {
//                    let json = JSON(jsonFormat)
//                    let result = json["code"].intValue
//                    if result == kCodeSuccess {
//                        return json["data"]["id"].intValue
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




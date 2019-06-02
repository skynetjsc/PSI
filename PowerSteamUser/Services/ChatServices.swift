//
//  ChatServices.swift
//  PowerSteamUser
//
//  Created by Mac on 5/31/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift

class ChatServices {
    
    /// get list conversation
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func listConversation(params: [String: Any]) -> Observable<[PConversationModel]> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.listChat, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> [PConversationModel] in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return json["data"].arrayValue.map { PConversationModel(json: $0) }
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// get content chat
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func contentChat(params: [String: Any]) -> Observable<PContentChatModel> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.contentChat, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PContentChatModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return PContentChatModel(json: json["data"])
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// send message
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func sendMessage(params: [String: Any]) -> Observable<PMessageModel> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .post, endpoint: EndpointAPI.sendMessage, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PMessageModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return PMessageModel(json: json["data"])
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

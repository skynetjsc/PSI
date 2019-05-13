//
//  BookingServices.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift

class BookingServices {
    
    /// get service list
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func getServiceList(params: [String: Any]) -> Observable<[PServiceModel]> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.service, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> [PServiceModel] in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return json["data"].arrayValue.map { PServiceModel(json: $0) }
                    } else {
                        throw APIError.error(responseCode: json["errorId"].intValue, data: json["message"].stringValue)
                    }
                } else {
                    throw APIError.invalidResponseData(data: data)
                }
            })
            .share(replay: 1)
    }
    
    /// get service category
    ///
    /// - Parameter params: dictionary object
    /// - Returns: Observable object
    func getServiceCategory(params: [String: Any]) -> Observable<PServicePackageModel> {
        //RxAlamofireClient.shared.headers["token"] = userDefaults.string(forKey: kAccessToken) ?? ""
        
        return RxAlamofireClient.shared.request(method: .get, endpoint: EndpointAPI.serviceCategory, parameters: params)
            .observeOn(MainScheduler.instance)
            .map({ (data) -> PServicePackageModel in
                if let jsonFormat = data as? [String: Any] {
                    let json = JSON(jsonFormat)
                    let result = json["errorId"].intValue
                    if result == kCodeSuccess {
                        return PServicePackageModel(json: json["data"])
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

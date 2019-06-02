//
//  PFeedbackModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class PFeedbackModel {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var userID: Int = 0
    @objc dynamic var content: String = ""
    @objc dynamic var response: String = ""
    @objc dynamic var dateCreate: String = ""   // 2018-12-21 10:11:22
    @objc dynamic var timeFeedback: String = ""   // 30\/05\/2019
    @objc dynamic var typeFeedback: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var active: Int = 0
    var listImage = [PImageModel]()
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = Int(json["id"].stringValue) ?? 0
        userID = Int(json["user_id"].stringValue) ?? 0
        content = json["content"].stringValue
        response = json["response"].stringValue
        dateCreate = json["date_create"].stringValue
        timeFeedback = json["time_feedback"].stringValue
        typeFeedback = json["type_feedback"].stringValue
        address = json["address"].stringValue
        active = Int(json["active"].stringValue) ?? 0
        for image in json["list_image"].arrayValue {
            listImage.append(PImageModel(json: image))
        }
    }
    
    var dateCreateDate: Date {
        if dateCreate.isEmpty {
            return Date()
        }
        if let date = dateCreate.toDate("yyyy-MM-dd HH:mm:ss")?.date {
            return date
        }
        return Date()
    }
}






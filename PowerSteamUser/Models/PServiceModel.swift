//
//  PServiceModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class PServiceModel {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var img: String = ""
    @objc dynamic var date: String = "" // 2018-12-13 16:11:30
    @objc dynamic var active: Int = 0
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = json["id"].intValue
        name = json["name"].stringValue
        content = json["content"].stringValue
        img = json["img"].stringValue
        date = json["date"].stringValue
        active = Int(json["active"].stringValue) ?? 0
    }
    
    var createDate: Date {
        if date.isEmpty {
            return Date()
        }
        if let date = date.toDate("yyyy-MM-dd HH:mm:ss")?.date {
            return date
        }
        return Date()
    }
}





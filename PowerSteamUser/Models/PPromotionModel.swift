//
//  PPromotionModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class PPromotionModel {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var code: String = ""
    @objc dynamic var type: Int = 0
    @objc dynamic var value: Int = 0
    @objc dynamic var dateStart: String = ""    // 24\/12\/2018
    @objc dynamic var dateEnd: String = ""      // 24\/12\/2018
    @objc dynamic var date: String = ""         // 2018-12-21 10:11:22
    @objc dynamic var timeStart: String = ""
    @objc dynamic var number: Int = 0
    @objc dynamic var typeBike: Int = 0
    @objc dynamic var active: Int = 0
    @objc dynamic var userRead: Int = 0
    @objc dynamic var isRead: Int = 0
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = Int(json["id"].stringValue) ?? 0
        title = json["title"].stringValue
        content = json["content"].stringValue
        code = json["code"].stringValue
        type = Int(json["type"].stringValue) ?? 0
        value = Int(json["value"].stringValue) ?? 0
        dateStart = json["date_start"].stringValue
        dateEnd = json["date_end"].stringValue
        date = json["date"].stringValue
        timeStart = json["time_start"].stringValue
        number = Int(json[number].stringValue) ?? 0
        typeBike = Int(json["type_bike"].stringValue) ?? 0
        active = Int(json["active"].stringValue) ?? 0
        userRead = json["user_read"].intValue
        isRead = Int(json["is_read"].stringValue) ?? 0
    }
    
    var vehicleType: VehicleType {
        return VehicleType(rawValue: self.typeBike) ?? .bike
    }
}




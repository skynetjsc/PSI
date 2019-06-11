//
//  PLocationModel.swift
//  PowerSteamUser
//
//  Created by Mac on 6/4/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class PLocationModel {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var franchiseId: Int = 0
    @objc dynamic var cityId: Int = 0
    @objc dynamic var parentId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var lat: Double = 0
    @objc dynamic var lng: Double = 0
    @objc dynamic var date: String = "" // 2018-12-13 16:11:30
    @objc dynamic var active: Int = 0
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = Int(json["id"].stringValue) ?? 0
        franchiseId = Int(json["franchise_id"].stringValue) ?? 0
        cityId = Int(json["city_id"].stringValue) ?? 0
        parentId = Int(json["parent_id"].stringValue) ?? 0
        name = json["name"].stringValue
        lat = Double(json["lat"].stringValue) ?? 0
        lng = Double(json["lng"].stringValue) ?? 0
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

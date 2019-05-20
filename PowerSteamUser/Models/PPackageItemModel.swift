//
//  PPackageItemModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/20/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class PPackageItemModel {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var serviceID: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var date: String = "" // 2018-12-15 10:06:16
    @objc dynamic var timeWork: Int = 0
    @objc dynamic var position: Int = 0
    @objc dynamic var active: Int = 0
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = json["id"].intValue
        serviceID = json["service_id"].intValue
        title = json["title"].stringValue
        timeWork = json["time_work"].intValue
        position = json["position"].intValue
        active = json["active"].intValue
        date = json["date"].stringValue
    }
    
    var createDate: Date {
        if date.isEmpty {
            return Date()
        }
        if let date = date.toDate("yyyy-MM-dd HH:mm:ss", region: PDefined.serverRegion)?.date {
            return date
        }
        return Date()
    }
}

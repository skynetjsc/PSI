//
//  PImageModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/25/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import SwiftyJSON
import UIKit

class PImageModel {
    
    @objc dynamic var active: String = ""
    @objc dynamic var date: String = "" // 2019-01-25 15:39:34
    @objc dynamic var id: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var postId: String = ""
    @objc dynamic var type: String = "" // 1: image, 2: video
    @objc dynamic var userId: String = ""
    @objc dynamic var bookingId: String = ""
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        active = json["active"].stringValue
        date = json["date"].stringValue
        id = json["id"].stringValue
        image = json["img"].stringValue
        if json["video"].stringValue.count > 0 {
            image = json["video"].stringValue
        }
        postId = json["post_id"].stringValue
        type = json["type"].stringValue
        userId = json["user_id"].stringValue
        bookingId = json["booking_id"].stringValue
    }
    
    var typeInt: Int {
        return Int(self.type) ?? 1
    }
    
    var activeInt: Int {
        return Int(self.active) ?? 0
    }
    
    var createdDate: Date {
        if date.isEmpty {
            return Date()
        }
        
        if let date = date.toDate("yyyy-MM-dd HH:mm:ss", region: PDefined.serverRegion)?.date {
            return date
        }
        return Date()
    }
}






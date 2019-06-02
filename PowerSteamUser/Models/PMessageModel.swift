//
//  PMessageModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/31/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate

enum ContentType: Int {
    case text = 0
    case image = 2
    case video = 3
    case audio = 4
    case file = 5
}

class PMessageModel {
    
    @objc dynamic var id: String = ""
    @objc dynamic var time: String = "" // 2019-05-31 06:29:59
    @objc dynamic var content: String = ""
    @objc dynamic var type: String = "" // 1: user, 3: tech
    @objc dynamic var contentType: String = "" //1: text, 2: image, 3: video, 4: audio, 5: file
    @objc dynamic var isOnline: Bool = false
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = json["id"].stringValue
        time = json["time"].stringValue
        content = json["content"].stringValue.decodeUrl() ?? ""
        type = json["type"].stringValue
        contentType = json["attach"].stringValue
    }
    
    var idInt: Int {
        return Int(id) ?? 0
    }
    
    var typeInt: Int {
        return Int(type) ?? 1
    }
    
    var contentTypeEnum: ContentType {
        return ContentType(rawValue: Int(contentType) ?? 1) ?? .text
    }
    
    var timeDate: Date {
        if time.isEmpty {
            return Date()
        }
        if let date = time.toDate("yyyy-MM-dd HH:mm:ss")?.date {
            return date
        }
        return Date()
    }
}




//
//  PContentChatModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/31/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate

class PContentChatModel {
    
    @objc dynamic var id: String = ""
    @objc dynamic var userId: String = ""
    @objc dynamic var techId: String = ""
    var listContent = [PMessageModel]()
    @objc dynamic var userRead: String = ""
    @objc dynamic var techRead: String = ""
    @objc dynamic var date: String = ""     // 2019-05-31 06:20:57
    @objc dynamic var active: String = ""
    @objc dynamic var avatarUser: String = ""
    @objc dynamic var nameUser: String = ""
    @objc dynamic var avatarTech: String = ""
    @objc dynamic var nameShop: String = ""
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = json["id"].stringValue
        userId = json["user_id"].stringValue
        techId = json["tech_id"].stringValue
        for listContentJson in json["content"].arrayValue {
            listContent.append(PMessageModel(json: listContentJson))
        }
        userRead = json["user_read"].stringValue
        techRead = json["tech_read"].stringValue
        date = json["date"].stringValue
        active = json["active"].stringValue
        avatarUser = json["avatar_user"].stringValue
        nameUser = json["name_user"].stringValue
        avatarTech = json["avatar_tech"].stringValue
        nameShop = json["name_shop"].stringValue
    }
}





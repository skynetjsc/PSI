//
//  PConversationModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/31/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate

class PConversationModel {
    
    @objc dynamic var id: String = ""
    @objc dynamic var lastMessage: String = ""
    @objc dynamic var date: String = "" // 2019-05-31 06:29:59
    @objc dynamic var user: PUserModel?
    @objc dynamic var tech: PUserModel?
    @objc dynamic var isOnline: Bool = false
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = json["id"].stringValue
        lastMessage = json["last_message"].stringValue.decodeUrl() ?? ""
        date = json["date"].stringValue
        if json["user"].exists() {
            tech = PUserModel(json: json["user"])
        }
        if json["tech"].exists() {
            tech = PUserModel(json: json["tech"])
        }
        isOnline = json["online"].boolValue
    }
    
    var idInt: Int {
        return Int(self.id) ?? 0
    }
}






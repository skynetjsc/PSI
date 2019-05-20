//
//  PTermsAgreementModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/15/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class PTermsAgreementModel {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var active: Int = 0
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = Int(json["id"].stringValue) ?? 0
        title = json["title"].stringValue
        content = json["content"].stringValue
        active = Int(json["active"].stringValue) ?? 0
    }
}

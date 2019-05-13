//
//  PServicePackageModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class PServicePackageModel {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var descrip: String = ""
    @objc dynamic var img: String = ""
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = json["id"].intValue
        name = json["name"].stringValue
        descrip = json["description"].stringValue
        img = json["img"].stringValue
    }
}

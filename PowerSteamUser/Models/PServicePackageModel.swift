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
    @objc dynamic var catID: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var type: Int = 0
    @objc dynamic var content: String = ""
    @objc dynamic var date: String = "" // 2018-12-13 16:11:30
    @objc dynamic var img: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var timeUsed: Int = 0
    @objc dynamic var active: Int = 0
    var items = [PPackageItemModel]()
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        id = json["id"].intValue
        catID = json["cat_id"].intValue
        name = json["name"].stringValue
        type = json["type"].intValue
        content = json["content"].stringValue
        date = json["date"].stringValue
        img = json["img"].stringValue
        price = json["price"].doubleValue
        timeUsed = json["time_used"].intValue
        active = json["active"].intValue
        
        for item in json["detail"].arrayValue {
            items.append(PPackageItemModel(json: item))
        }
    }
}

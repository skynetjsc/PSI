//
//  PBookModel.swift
//  PowerSteamUser
//
//  Created by Mac Mini on 5/20/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class PBookModel {
    
    @objc dynamic var bookingID: Int = 0
    @objc dynamic var lat: Double = 0
    @objc dynamic var lng: Double = 0
    var listTechs = [PUserModel]()
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        bookingID = json["booking_id"].intValue
        lat = json["lat"].doubleValue
        lng = json["lng"].doubleValue
        for item in json["list_tech"].arrayValue {
            listTechs.append(PUserModel(json: item))
        }
    }
}

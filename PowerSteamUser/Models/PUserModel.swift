//
//  PUserModel.swift
//  Receigo
//
//  Created by Mac on 11/12/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate

class PUserModel: NSObject, NSCoding {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var date: String = "" // 2018-12-13 16:11:30
    @objc dynamic var level: Int = 1
    @objc dynamic var typeBike: Int = 1
    @objc dynamic var avatar: String = ""
    @objc dynamic var birthday: String = "" // 12\/07\/2018
    @objc dynamic var gender: Int = 1
    @objc dynamic var imei: String = ""
    @objc dynamic var account: Int = 0
    @objc dynamic var active: Int = 1
    
    // For tech
    @objc dynamic var bookingID: Int = 1
    @objc dynamic var lat: Double = 0
    @objc dynamic var lng: Double = 0
    @objc dynamic var distance: Double = 0
    
    init(json: JSON!) {
        if json.isEmpty { return }
        
        id = Int(json["id"].stringValue) ?? 0
        name = json["name"].stringValue
        password = json["password"].stringValue
        phone = json["phone"].stringValue
        email = json["email"].stringValue
        address = json["address"].stringValue
        date = json["date"].stringValue
        level = Int(json["level"].stringValue) ?? 1
        typeBike = Int(json["type_bike"].stringValue) ?? 1
        avatar = json["avatar"].stringValue
        birthday = json["birthday"].stringValue
        gender = Int(json["gender"].stringValue) ?? 1
        imei = json["imei"].stringValue
        account = Int(json["account"].stringValue) ?? 0
        active = Int(json["active"].stringValue) ?? 1
        
        bookingID = json["booking_id"].intValue
        lat = json["lat"].doubleValue
        lng = json["lng"].doubleValue
        distance = json["ldistanceat"].doubleValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(typeBike, forKey: "typeBike")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(birthday, forKey: "birthday")
        aCoder.encode(gender, forKey: "gender")
        aCoder.encode(imei, forKey: "imei")
        aCoder.encode(account, forKey: "account")
        aCoder.encode(active, forKey: "active")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        password = aDecoder.decodeObject(forKey: "password") as? String ?? ""
        phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        date = aDecoder.decodeObject(forKey: "date") as? String ?? ""
        level = aDecoder.decodeInteger(forKey: "level")
        typeBike = aDecoder.decodeInteger(forKey: "typeBike")
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String ?? ""
        birthday = aDecoder.decodeObject(forKey: "birthday") as? String ?? ""
        gender = aDecoder.decodeInteger(forKey: "gender")
        imei = aDecoder.decodeObject(forKey: "imei") as? String ?? ""
        account = aDecoder.decodeInteger(forKey: "account")
        active = aDecoder.decodeInteger(forKey: "active")
    }
    
    var birthdayDate: Date {
        if birthday.isEmpty {
            return Date()
        }
        if let date = date.toDate("dd/MM/yyyy", region: PDefined.serverRegion)?.date {
            return date
        }
        return Date()
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





















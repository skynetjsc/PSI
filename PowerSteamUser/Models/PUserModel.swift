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
    @objc dynamic var date: String = "" // 2018-10-09 14:21:46
    @objc dynamic var active: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var avatar: String = ""
    @objc dynamic var chucdanhID: Int = 0
    @objc dynamic var cosoID: Int = 0
    @objc dynamic var token: String = ""
    @objc dynamic var timeExpire: Int = 0
    @objc dynamic var level: Int = 0
    @objc dynamic var code: String = ""
    @objc dynamic var role: String = ""
    
    // in remark
    @objc dynamic var timeTest: String = ""
    @objc dynamic var registerID: Int = 0
    @objc dynamic var status: Int = 0
    
    init(json: JSON!) {
        if json.isEmpty { return }
        
        id = json["id"].intValue
        date = json["date"].stringValue
        active = json["active"].intValue
        name = json["name"].stringValue
        username = json["username"].stringValue
        password = json["password"].stringValue
        phone = json["phone"].stringValue
        email = json["email"].stringValue
        avatar = json["avatar"].stringValue
        chucdanhID = json["chucdanh_id"].intValue
        cosoID = json["coso_id"].intValue
        token = json["token"].stringValue
        timeExpire = json["time_expire"].intValue
        level = json["level"].intValue
        code = json["code"].stringValue
        role = json["role"].stringValue
        
        timeTest = json["time_test"].stringValue
        registerID = json["register_id"].intValue
        status = json["status"].intValue
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(active, forKey: "active")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(avatar, forKey: "avatar")
        aCoder.encode(chucdanhID, forKey: "chucdanhID")
        aCoder.encode(cosoID, forKey: "cosoID")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(timeExpire, forKey: "timeExpire")
        aCoder.encode(level, forKey: "level")
        aCoder.encode(code, forKey: "code")
        aCoder.encode(role, forKey: "role")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        date = aDecoder.decodeObject(forKey: "date") as? String ?? ""
        active = aDecoder.decodeInteger(forKey: "active")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        username = aDecoder.decodeObject(forKey: "username") as? String ?? ""
        password = aDecoder.decodeObject(forKey: "password") as? String ?? ""
        phone = aDecoder.decodeObject(forKey: "phone") as? String ?? ""
        email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String ?? ""
        chucdanhID = aDecoder.decodeInteger(forKey: "chucdanhID")
        cosoID = aDecoder.decodeInteger(forKey: "cosoID")
        token = aDecoder.decodeObject(forKey: "token") as? String ?? ""
        timeExpire = aDecoder.decodeInteger(forKey: "timeExpire")
        level = aDecoder.decodeInteger(forKey: "level")
        code = aDecoder.decodeObject(forKey: "code") as? String ?? ""
        role = aDecoder.decodeObject(forKey: "role") as? String ?? ""
    }
    
    var birthday: Date {
        if date.isEmpty {
            return Date()
        }
        if let date = date.toDate("yyyy-MM-dd HH:mm:ss", region: PDefined.serverRegion)?.date {
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





















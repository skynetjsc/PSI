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
    @objc dynamic var tech: PUserModel?
    @objc dynamic var user: PUserModel?
    var listTechs = [PUserModel]()
    // active - 1: chưa ghép, 2: đã ghép, 3: đang thực hiện, 4: hoàn thành, 5: khách hàng huỷ, 6: kỹ thuật huỷ, 7: hệ thống hủy
    @objc dynamic var active: Int = 1
    @objc dynamic var address: String = ""
    @objc dynamic var currency: Int = 1
    @objc dynamic var dateCreate: String = ""   // 2019-05-22 14:48:26
    @objc dynamic var dateWorking: String = ""  // 05\/22\/2019
    @objc dynamic var hourWorking: String = ""  // 07:48
    @objc dynamic var id: String = ""
    @objc dynamic var idPromotion: Int = 0
    var listImage = [PImageModel]()
    @objc dynamic var locationId: Int = 0
    @objc dynamic var methodPayment: Int = 0
    @objc dynamic var note: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var rating: Int = 0
    @objc dynamic var repeatType: Int = 0
    @objc dynamic var serviceId: Int = 0
    @objc dynamic var serviceImage: String = ""
    @objc dynamic var serviceName: String = ""
    @objc dynamic var techId: Int = 0
    @objc dynamic var timeWorking: String = ""
    @objc dynamic var dayString: String = ""
    @objc dynamic var typeBike: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var userName: String = ""
    @objc dynamic var promotionValue: Int = 0
    var serviceItems = [PPackageItemModel]()
    
    convenience init(json: JSON!) {
        self.init()
        
        if json.isEmpty { return }
        
        if json["booking_id"].exists() {
            bookingID = json["booking_id"].intValue
        } else if json["id"].exists() {
            bookingID = Int(json["id"].stringValue) ?? 0
        }
        
        lat = Double(json["lat"].stringValue) ?? 0
        lng = Double(json["lng"].stringValue) ?? 0        
        for item in json["list_tech"].arrayValue {
            listTechs.append(PUserModel(json: item))
        }
        if json["tech"].exists() {
            tech = PUserModel(json: json["tech"])
        }
        if json["user"].exists() {
            user = PUserModel(json: json["user"])
        }
        active = Int(json["active"].stringValue) ?? 1
        address = json["address"].stringValue
        currency = Int(json["currency"].stringValue) ?? 1
        dateCreate = json["date_create"].stringValue
        dateWorking = json["date_working"].stringValue
        hourWorking = json["hour_working"].stringValue
        id = json["id"].stringValue
        idPromotion = Int(json["id_promotion"].stringValue) ?? 0
        for image in json["list_image"].arrayValue {
            listImage.append(PImageModel(json: image))
        }
        locationId = Int(json["location_id"].stringValue) ?? 0
        methodPayment = Int(json["method_payment"].stringValue) ?? 0
        note = json["note"].stringValue
        price = Double(json["price"].stringValue) ?? 0
        rating = Int(json["rating"].stringValue) ?? 0
        repeatType = Int(json["repeat_type"].stringValue) ?? 0
        serviceId = Int(json["service_id"].stringValue) ?? 0
        serviceImage = json["service_image"].stringValue
        serviceName = json["service_name"].stringValue
        techId = Int(json["tech_id"].stringValue) ?? 0
        timeWorking = json["time_working"].stringValue
        dayString = json["day_string"].stringValue
        typeBike = Int(json["type_bike"].stringValue) ?? 0
        userId = Int(json["user_id"].stringValue) ?? 0
        userName = json["user_name"].stringValue
        promotionValue = json["promotion_value"].intValue
        for item in json["service_detail"].arrayValue {
            serviceItems.append(PPackageItemModel(json: item))
        }
    }
    
    var bookActiveType: BookActiveType {
        return BookActiveType(rawValue: self.active) ?? .notAssign
    }
    
    var paymentType: PaymentType {
        return PaymentType(rawValue: self.methodPayment) ?? .cash
    }
    
    var vehicleType: VehicleType {
        return VehicleType(rawValue: self.typeBike) ?? .bike
    }
    
    var repeatTypeEnum: RepeatType {
        return RepeatType(rawValue: self.repeatType) ?? .none
    }
}

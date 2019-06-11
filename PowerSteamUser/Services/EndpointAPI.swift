//
//  EndpointAPI.swift
//  Receigo
//
//  Created by Mac on 11/12/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation

/// Refer document API: https://docs.google.com/spreadsheets/d/1_jNVC2DBfoWoPyVhSA3FUS3x6Z8zTJw9FNsF0qPbmVA/edit#gid=0

public let kBasePath                = Bundle.main.object(forInfoDictionaryKey: "BASE_URL")
public let kPrePhone                = Bundle.main.object(forInfoDictionaryKey: "PRE_PHONE") as? String ?? "+81"

class EndpointAPI {
    
    //static let baseURL              = "\(kBasePath ?? "http://cms.powersteam.vn")/api/"
    static let baseURL              = "\(kBasePath ?? "http://powersteaminc.site")/api/"
    
    // User
    static let login                = baseURL + "login.php"
    static let getInfo              = baseURL + "get_info.php"
    static let register             = baseURL + "register.php"
    static let verifyCode           = baseURL + "verify_code.php"
    static let forgetPassword       = baseURL + "forget_password.php"
    static let updateAvatar         = baseURL + "update_avatar.php"
    static let logout               = baseURL + "logout.php"
    static let registerDevice       = baseURL + "update_token_ios.php"
    
    static let privacy              = baseURL + "privacy.php"
    static let term                 = baseURL + "term.php"
    
    static let addCar               = baseURL + "add_car.php"
    
    // Booking
    static let service              = baseURL + "service.php"
    static let serviceCategory      = baseURL + "service_category.php"
    static let booking              = baseURL + "booking.php"
    static let statusBooking        = baseURL + "status_booking.php"
    static let history              = baseURL + "history.php"
    static let bookingDetail        = baseURL + "booking_detail.php"
    static let rating               = baseURL + "rating.php"
    static let schedule             = baseURL + "schedule.php"
    
    // Common
    static let promotion            = baseURL + "promotion.php"
    static let promotionDetail      = baseURL + "promotion_detail.php"
    static let sendFeedback         = baseURL + "feedback.php"
    static let listFeedback         = baseURL + "list_feedback.php"
    static let feedbackDetail       = baseURL + "feedback_detail.php"
    static let location             = baseURL + "location.php"
    
    // Chat
    static let listChat             = baseURL + "list_chat.php"
    static let contentChat          = baseURL + "content_chat.php"
    static let sendMessage          = baseURL + "chat.php"
}













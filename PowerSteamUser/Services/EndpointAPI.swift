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
    
    static let baseURL              = "\(kBasePath ?? "http://cms.powersteam.vn")/api/"
    
    // User
    static let login                = baseURL + "login.php"
    static let getInfo              = baseURL + "get_info.php"
    static let register             = baseURL + "user/register"
    static let profile              = baseURL + "user/profile"
    static let updateAvatar         = baseURL + "update_avatar.php"
    static let logout               = baseURL + "logout.php"
    static let registerDevice       = baseURL + "user/register-device"
    
    // Booking
    static let service              = baseURL + "service.php"
    static let serviceCategory      = baseURL + "service_category.php"
    
}













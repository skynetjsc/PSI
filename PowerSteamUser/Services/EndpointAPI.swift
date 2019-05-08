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
    
    static let baseURL              = "\(kBasePath ?? "http://vinperldemo.online")/api_phieucham/"
    
    // User
    static let login                = baseURL + "login.php"
    static let getInfo              = baseURL + "get_info.php"
    static let register             = baseURL + "user/register"
    static let profile              = baseURL + "user/profile"
    static let updateAvatar         = baseURL + "update_avatar.php"
    static let logout               = baseURL + "logout.php"
    static let registerDevice       = baseURL + "user/register-device"
    
    static let history              = baseURL + "history.php"
    static let historyDetail        = baseURL + "history_detail.php"
    static let mark                 = baseURL + "mark.php"
    static let remark               = baseURL + "remark.php"
    static let remarkDetail         = baseURL + "remark_detail.php"
    static let confirmRemark        = baseURL + "confirm_remark.php"
    static let remarking            = baseURL + "remarking.php"
    static let confirmMark          = baseURL + "confirm_mark.php"
    static let cardContent          = baseURL + "card_content.php"
    static let cardDetail           = baseURL + "card_detail.php"
    static let searchStudent        = baseURL + "search_student.php"
    static let updateImageCard      = baseURL + "update_image_card.php"
    
}













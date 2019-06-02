//
//  PConstants.swift
//  Supership
//
//  Created by Mac on 8/10/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import Localize_Swift
import UIKit

// MARK: CompletionHandler
typealias CompletionHandler = (Bool, Int, Any?) -> ()

// MARK: Standard UserDefault
public let userDefaults = UserDefaults.standard
public let kDeviceToken = "kDeviceToken"
public let kAccessToken = "kAccessToken"
public let kAuthToken   = "kAuthToken"
public let kDeviceUUID  = "kDeviceUUID"
public let kVendorDeviceUUID    = "kVendorDeviceUUID"
public let kFirstOpenApp        = "kFirstOpenApp"
public let kAcceptedAgreement   = "kAcceptedAgreement"
public var kUUID: String = ""
public var kFCMToken: String = ""

public var kEnableNotification: Bool? {
    get {
        return userDefaults.bool(forKey: "EnableNotification")
    }
    set {
        userDefaults.set(newValue, forKey: "EnableNotification")
    }
}

// MARK: Device Constant
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let OS_VERSION = UIDevice.current.systemVersion

// MARK: - Public Constants and Function
public let kTimeoutRequest = TimeInterval(60)
public let kImageQualityUpload = CGFloat(0.7)
public let kImageSizeUpload = CGFloat(640)

// MARK: Notification
public let kLoginNotification               = "kLoginNotification"
public let kLogoutNotification              = "kLogoutNotification"
public let kDidEnterBackgroundNotification  = "kDidEnterBackgroundNotification"
public let kDidBecomeActiveNotification     = "kDidBecomeActiveNotification"
public let kDidEditGroupNotification        = "kDidEditGroupNotification"
public let kDidDeleteGroupNotification      = "kDidDeleteGroupNotification"
public let kDidLeaveGroupNotification       = "kDidLeaveGroupNotification"
public let kRefreshConversationNotification = "kRefreshConversationNotification"
public let kRefreshNewsFeedNotification     = "kRefreshNewsFeedNotification"
public let kRefreshPostListNotification     = "kRefreshPostListNotification"
public let kRefreshVideoListNotification     = "kRefreshVideoListNotification"

// MARK: Third key
public let kOneSignalAppID = "0562a1e8-ea58-48a2-9685-45d5dfe81867"
public let kOneSignalUserKey = "kOneSignalUserKey"

public let kTwitterConsumerKey = Bundle.main.object(forInfoDictionaryKey: "TwitterConsumerKey") as? String ?? ""
public let kTwitterConsumerSecret = Bundle.main.object(forInfoDictionaryKey: "TwitterConsumerSecret") as? String ?? ""

// MARK: Apple store
public let kAppStoreID = "1356920058"
public let kAppStoreUrl = "itms-apps://itunes.apple.com/app/id%@"

public let kGoogleClientID = "546838806559-rksv6ce356f16vne35kh2c5h2pg6a5li.apps.googleusercontent.com"
public let kGoogleReversedClientID = "com.googleusercontent.apps.508795560004-2uj4po300c8a8v75o0s3b7dpobva0mgn"

// MARK: Google Place
public let kPlacesAPIKey = "AIzaSyD89SAwZAK3SuiyF9jfckdN0OKuQOop0x8"
public let kGoogleMapKey = "AIzaSyD89SAwZAK3SuiyF9jfckdN0OKuQOop0x8"
public let kPlacesSearchAPIKey = "AIzaSyDNaxV6tecldXTshO0Gf2ZbcMbLhh_Uk0k"
public let GoogleNearBySearchUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"

// MARK: Local string function
func LANGTEXT(key: String)-> String {
    return key.localized()
}

func getCurrentLangtext() -> String {
    return Localize.currentLanguage()
}

func setLanguage(language: String) {
    let local = Localize.availableLanguages()
    if local.contains(language) {
        Localize.setCurrentLanguage(language)
    }
}

public var isiPhoneXModel: Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        switch UIScreen.main.nativeBounds.height {
        case 1792, 2436, 2688:
            return true
        default:
            return false
        }
    }
    return false
}

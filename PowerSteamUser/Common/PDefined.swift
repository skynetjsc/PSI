//
//  PDefined.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import SwiftDate
import UIKit

class PDefined: NSObject {
    
    override init() {
        //check font name
        /*
        for family in UIFont.familyNames {
            print(family)
            for names in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
        */
    }
    // MARK: - Font
    
    static func fontBold(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!
    }
    static func fontRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans", size: size)!
    }
    static func fontMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Semibold", size: size)!
    }
    static func fontTitle() -> UIFont {
        return PDefined.fontBold(size: 16)
    }
    static func fontLargeTitle() -> UIFont {
        return PDefined.fontBold(size: 25)
    }
    static func fontButton() -> UIFont {
        return PDefined.fontBold(size: 16)
    }
    static func fontStandard() -> UIFont {
        return PDefined.fontRegular(size: 16)
    }
    
    
    // MARK: - Color
    
    static let mainColor = UIColor(hexString: "00C464")
    static let headerColor = UIColor(hexString: "FFFFFF")
    static let headerTintColor = UIColor(hexString: "2A2A2A")
    static let normalTextColor = UIColor(hexString: "193628")
    static let boldTextColor = UIColor(hexString: "2B2B2B")
    static let inactiveTextColor = UIColor(hexString: "A1AAB1")
    static let lineColor = UIColor(hexString: "000000").withAlphaComponent(0.06)
    static let backgroudTabbarColor = UIColor(hexString: "FFFFFF").withAlphaComponent(1.0)
    static let selectedTabbarColor = UIColor(hexString: "479CDC")
    static let normalTabbarColor = UIColor(hexString: "999999")
    static let selectedButtonColor = UIColor(hexString: "479CDC")
    static let enableButtonColor = UIColor(hexString: "479CDC")
    static let disableButtonColor = UIColor(hexString: "CCCCCC")
    static let errorColor = UIColor(hexString: "DB3E51")
    static let onlineColor = UIColor(hexString: "7ED321")
    static let offlineColor = UIColor(hexString: "98AAB0")
    static let redColor = UIColor(hexString: "D0021B")
    static let orangeColor = UIColor(hexString: "F76B1C")
    static let startGradientColor = UIColor(hexString: "FFAF23")
    static let endGradientColor = UIColor(hexString: "FF6B23")
    static let selectedPageColor = UIColor(hexString: "FF5858")
    
    static let placeholderImage = UIImage.imageWithColor(UIColor.groupTableViewBackground)
    static let noAvatar = UIImage(named: "noavatar")
    
    // Server region
    static let serverRegion = Region(calendar: Calendars.gregorian, zone: Zones.asiaHoChiMinh, locale: Locales.vietnamese) // vietnam region
    //Date.setDefaultRegion(japanRegion)
    //static let serverRegion = Region.UTC
    
    static let minTransfer: Double = 221 // minimum transfer ¥221
    static let bankYuchoCode = "9900"
}

enum ExamType: Int {
    case new = 1
    case retest = 2
    case reference
    
    var name: String {
        switch self {
        case .new:
            return "Hoàn thành".localized()
        case .retest:
            return "Thi lại".localized()
        case .reference:
            return "Phúc khảo".localized()
        }
    }
    
    var color: UIColor {
        switch self {
        case .new:
            return UIColor(hexString: "7ED321")
        case .retest:
            return UIColor(hexString: "D0021B")
        case .reference:
            return UIColor(hexString: "F76B1C")
        }
    }
}

enum ExamActive: Int {
    case registered = 1
    case examing = 2
    case finishedExam = 3
    
    var name: String {
        switch self {
        case .registered:
            return "Đã đăng ký".localized()
        case .examing:
            return "Đang thi".localized()
        case .finishedExam:
            return "Hoàn thành".localized()
        }
    }
    
    var color: UIColor {
        switch self {
        case .registered:
            return UIColor(hexString: "7ED321")
        case .examing:
            return UIColor(hexString: "D0021B")
        case .finishedExam:
            return UIColor(hexString: "00C464")
        }
    }
}




















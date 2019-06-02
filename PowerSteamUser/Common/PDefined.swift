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
        return UIFont(name: "Nunito-Bold", size: size)!
    }
    static func fontExtraBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Nunito-ExtraBold", size: size)!
    }
    static func fontRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Nunito-Regular", size: size)!
    }
    static func fontMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Nunito-SemiBold", size: size)!
    }
    static func fontItalic(size: CGFloat) -> UIFont {
        return UIFont(name: "Nunito-Italic", size: size)!
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
    static let selectedTabbarColor = UIColor(hexString: "00C464")
    static let normalTabbarColor = UIColor(hexString: "999999")
    static let selectedButtonColor = UIColor(hexString: "479CDC")
    static let enableButtonColor = UIColor(hexString: "479CDC")
    static let disableButtonColor = UIColor(hexString: "CCCCCC")
    static let errorColor = UIColor(hexString: "DB3E51")
    static let onlineColor = UIColor(hexString: "7ED321")
    static let offlineColor = UIColor(hexString: "98AAB0")
    static let redColor = UIColor(hexString: "FF1313")
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

enum VehicleType: Int {
    
    case sedan = 1
    case suv = 2
    case bike = 3
    
    var name: String {
        switch self {
        case .sedan:
            return "Sedan".localized()
        case .suv:
            return "SUV".localized()
        case .bike:
            return "Bike".localized()
        }
    }
    
    var image: UIImage {
        switch self {
        case .sedan:
            return #imageLiteral(resourceName: "car")
        case .suv:
            return #imageLiteral(resourceName: "suv")
        case .bike:
            return #imageLiteral(resourceName: "bike")
        }
    }
}

enum AgreementType: String {
    
    case privacy = "privacy"
    case term = "term"
}

enum RepeatType: Int {
    
    static let allValues = [none, day, week, month]
    
    case none = 0
    case day = 1
    case week = 2
    case month = 3
    
    var name: String {
        switch self {
        case .none:
            return "Không lặp lại".localized()
        case .day:
            return "Lặp lại 1 ngày/lần".localized()
        case .week:
            return "Lặp lại 2 tuần/lần".localized()
        case .month:
            return "Lặp lại 3 tháng/lần".localized()
        }
    }
    
    var scheduleName: String {
        switch self {
        case .none, .day:
            return "Hàng ngày".localized()
        case .week:
            return "Hàng tuần".localized()
        case .month:
            return "Hàng tháng".localized()
        }
    }
}


// active - 1: chưa ghép, 2: đã ghép, 3: đang thực hiện, 4: hoàn thành, 5: khách hàng huỷ, 6: kỹ thuật huỷ, 7: hệ thống hủy
enum BookActiveType: Int {
    
    case notAssign = 1
    case assigned = 2
    case doing = 3
    case completed = 4
    case userCanceled = 5
    case techCanceled = 6
    case systemCanceled = 7
    
    var name: String {
        switch self {
        case .notAssign:
            return "Chờ xác nhận".localized()
        case .assigned:
            return "Kỹ thuật đã nhận".localized()
        case .doing:
            return "Đang thực hiện".localized()
        case .completed:
            return "Hoàn thành".localized()
        case .userCanceled:
            return "Khách hàng huỷ".localized()
        case .techCanceled:
            return "Kỹ thuật huỷ".localized()
        case .systemCanceled:
            return "Hệ thống hủy".localized()
        }
    }
    
    var color: UIColor {
        switch self {
        case .notAssign:
            return UIColor(hexString: "193628")
        case .assigned:
            return UIColor(hexString: "DE8E3C")
        case .doing:
            return UIColor(hexString: "00C464")
        case .completed:
            return UIColor(hexString: "00C464")
        case .userCanceled, .techCanceled, .systemCanceled:
            return UIColor(hexString: "FF1313")
        }
    }
}




















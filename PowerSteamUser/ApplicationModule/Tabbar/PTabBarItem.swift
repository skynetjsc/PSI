//
//  PTabBarItem.swift
//  PowerSteamUser
//
//  Created by Mac on 5/21/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit

enum PTabBarItem {
    
    case home
    case service
    case history
    case more
    
    var title: String {
        switch self {
        case .home:
            return "".localized()
        case .service:
            return "".localized()
        case .history:
            return "".localized()
        case .more:
            return "".localized()
        }
    }
    
    var image: UIImage {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "tabbar-home").withRenderingMode(.alwaysOriginal)
        case .service:
            return #imageLiteral(resourceName: "tabbar-service").withRenderingMode(.alwaysOriginal)
        case .history:
            return #imageLiteral(resourceName: "tabbar-schedule").withRenderingMode(.alwaysOriginal)
        case .more:
            return #imageLiteral(resourceName: "tabbar-more").withRenderingMode(.alwaysOriginal)
        }
    }
    
    var selectedImage: UIImage {
        switch self {
        case .home:
            return #imageLiteral(resourceName: "tabbar-home-active").withRenderingMode(.alwaysOriginal)
        case .service:
            return #imageLiteral(resourceName: "tabbar-service-active").withRenderingMode(.alwaysOriginal)
        case .history:
            return #imageLiteral(resourceName: "tabbar-schedule-active").withRenderingMode(.alwaysOriginal)
        case .more:
            return #imageLiteral(resourceName: "tabbar-more-active").withRenderingMode(.alwaysOriginal)
        }
    }
}







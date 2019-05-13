//
//  AStarType.swift
//  anytime
//
//  Created by NhatQuang on 2/3/18.
//

import Foundation
import UIKit


enum StarType {
	case small
	case medium
	case large
	
	var image: UIImage {
		switch self {
		case .small:
            return #imageLiteral(resourceName: "Star")
        case .large:
            return #imageLiteral(resourceName: "star-large-yellow")
		default:
			return #imageLiteral(resourceName: "star-large-yellow")
		}
	}
	
	var activeColor: UIColor {
		return UIColor.colorFromHexString(hex: "FFDC84")
	}
	
	var inactiveColor: UIColor {
		return UIColor.colorFromHexString(hex: "FFFFFF")
	}
}























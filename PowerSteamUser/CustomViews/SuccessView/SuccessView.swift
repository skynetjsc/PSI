//
//  SuccessView.swift
//  WeWorld
//
//  Created by NhatQuang on 1/21/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

class SuccessView: MessageView {
    
	@IBOutlet weak var imageViewBound: PView! {
		didSet {
			imageViewBound.backgroundColor = UIColor.colorFromHexString(hex: "35474F")
			imageViewBound.layer.masksToBounds = false
			imageViewBound.layer.shadowColor = UIColor.colorFromHexString(hex: "#35474F").cgColor
			imageViewBound.layer.shadowOpacity = 0.5
			imageViewBound.layer.shadowOffset = CGSize(width: 0, height: 0)
			imageViewBound.layer.shadowRadius = 10
		}
	}
	
	@IBOutlet weak var tickImageView: UIImageView! {
		didSet {
			tickImageView.image = #imageLiteral(resourceName: "tick").withRenderingMode(.alwaysTemplate)
			tickImageView.tintColor = UIColor.white
		}
	}
	
}

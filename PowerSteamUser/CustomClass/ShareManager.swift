//
//  ShareManager.swift
//  WeWorld
//
//  Created by NhatQuang on 1/25/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import UIKit

extension UIActivity.ActivityType {
    
    public static let allValues: [UIActivity.ActivityType] = [.postToFacebook, .postToTwitter, .postToWeibo, .message, .mail, .print,
                                                              .copyToPasteboard, .assignToContact, .saveToCameraRoll, .addToReadingList,
                                                              .postToFlickr, .postToVimeo, .postToTencentWeibo, .airDrop, .openInIBooks]
}

class ShareManager: NSObject {
	
	weak var sourceViewController: UIViewController?
    
	init(sourceViewController: UIViewController) {
		self.sourceViewController = sourceViewController
	}
	
	let defaultStringToShare = """
	Check out \(PAboutApp.appName)...You can use \(PAboutApp.appName) to make international connections.
	"""
}

// MARK: - Share
extension ShareManager {
    
    func share(contents: [Any] = [], includedActivityTypes: [UIActivity.ActivityType]? = nil, completion: ((Int, String) -> Void)?) {
		var contentToShare = contents
		
		// Default for App
		if contents.count == 0 {
			contentToShare = [defaultStringToShare]
		}
		
		// set up activity view controller
		let activityViewController = UIActivityViewController(activityItems: contentToShare, applicationActivities: nil)
		activityViewController.popoverPresentationController?.sourceView = sourceViewController?.view // so that iPads won't crash
		
		// exclude some activity types from the list (optional)
        var excludedActivityTypes: [UIActivity.ActivityType] = []
        if let includedActivityTypes = includedActivityTypes {
            UIActivity.ActivityType.allValues.forEach { (activityType) in
                if !includedActivityTypes.contains(activityType) {
                    excludedActivityTypes.append(activityType)
                }
            }
        }
		activityViewController.excludedActivityTypes = excludedActivityTypes
		
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            if let error = error {
                completion?(0, error.localizedDescription)
            } else if success, let activity = activity {
                completion?(1, activity.rawValue)
            }
        }
        
		// present the view controller
		sourceViewController?.present(activityViewController, animated: true, completion: nil)
	}
}


//
//  WOneSignalSetup.swift
//  WeWorld
//
//  Created by NhatQuang on 12/26/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import Foundation
import UIKit
import OneSignal
import RxCocoa
import RxSwift

class OneSignalSetup: NSObject {
	
	static let shared = OneSignalSetup()
	let userServices = UserServices()
	let disposeBag = DisposeBag()
    
    var launchOptions: [UIApplication.LaunchOptionsKey: Any]? {
		didSet {
			setup()
		}
	}
	
    func setup() {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: kOneSignalAppID,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.none
        let userID = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
        userDefaults.set(userID, forKey: kOneSignalUserKey)
        if let userID = userID {
            sendPlayerID(playerID: userID)
        }
		
        OneSignal.add(self)
		
		PAppManager.shared.userLogout.asObserver()
			.subscribe(onNext: {
				OneSignal.setSubscription(false)
			})
			.disposed(by: disposeBag)
    }
}



// MARK: - Delegate
extension OneSignalSetup: OSSubscriptionObserver {
    
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        if !stateChanges.from.subscribed && stateChanges.to.subscribed, let playerID = stateChanges.to.userId {
            print("Subscribed for OneSignal push notifications!")
            print("PlayerID: \(playerID)")
            userDefaults.set(playerID, forKey: kOneSignalUserKey)
            sendPlayerID(playerID: playerID)
        }
        print("SubscriptionStateChange: \n\(stateChanges)")
    }
    
    func sendPlayerID(playerID: String) {
		let params: [String: Any] = ["deviceId": playerID,
									 "device_type": 0]
		userServices.postDevice(param: params)
			.subscribe(onNext: { _ in
				// write code here
			})
			.disposed(by: disposeBag)
	}
	
	func updatePlayerID() {
		OneSignal.setSubscription(true)
		guard let userID = userDefaults.string(forKey: kOneSignalUserKey) else {
			return
		}
		sendPlayerID(playerID: userID)
	}
	
	func unRegister() {
		OneSignal.setSubscription(false)
	}
}






























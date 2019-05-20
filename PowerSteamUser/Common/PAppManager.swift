//
//  PAppManager.swift
//  Supership
//
//  Created by Mac on 8/10/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON
import UserNotifications
//import RealmSwift

class PAppManager {
    
    static let shared = PAppManager()
    let disposeBag = DisposeBag()
    let userServices = UserServices()
    
    var accessToken: String? {
        get {
            return userDefaults.string(forKey: kAccessToken)
        }
        set {
            userDefaults.set(newValue, forKey: kAccessToken)
        }
    }
    
    var acceptedAgreement: Bool {
        get {
            return userDefaults.bool(forKey: kAcceptedAgreement)
        }
        set {
            userDefaults.set(newValue, forKey: kAcceptedAgreement)
        }
    }
    
    var deviceID: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    
    var currentUser: PUserModel? {
        get {
            if let data = userDefaults.object(forKey: "PUserModel") as? Data,
                let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? PUserModel {
                return user
            }
            return nil
        }
        set {
            if let value = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: value)
                userDefaults.set(data, forKey: "PUserModel")
            } else {
                userDefaults.removeObject(forKey: "PUserModel")
            }
        }
    }
    
    let unreadCount = BehaviorRelay<Int>(value: 0)
    
    // User state
    let userLogout = PublishSubject<Void>()
    
    init() {
        userLogout.asObservable()
            .subscribe(onNext: {
                self.accessToken = nil
                self.currentUser = nil
            })
            .disposed(by: disposeBag)
    }
    
    func getProfile() {
        userServices.getProfile(params: ["id": accessToken ?? ""]).asObservable()
            .subscribe { [weak self] (event) in
                switch event {
                case .next(let userModel):
                    self?.currentUser = userModel
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Push notification handle

extension PAppManager {
    
    enum RemoteNotificationType: Int {
        case UNKNOWN = 0
        case ACTION_STAFF = 1
        case ACTION_MANAGER = 2
    }
    
    func handlePushNotification(content: [AnyHashable : Any]) {
        let actionID = JSON(content)["custom"]["a"]["action_id"].intValue
        let projectID = JSON(content)["custom"]["a"]["project_id"].intValue
        let planDate = JSON(content)["custom"]["a"]["plan_date"].stringValue
        let notificationType = RemoteNotificationType(rawValue: actionID) ?? .UNKNOWN
        if UIApplication.shared.applicationState == UIApplication.State.active {
            showGLNotificationWith(content)
            
            // refresh current view
            //if PAppManager.shared.currentUser.value == nil { return }
            guard let topVC = UIApplication.topVC() else { return }
            switch notificationType {
            case .ACTION_STAFF:
//                if let staffReportVC = topVC as? StaffReportVC {
//                    if planDate.count > 0 {
//                        if let date = planDate.toDate("yyyy-MM-dd", region: PDefined.serverRegion)?.date {
//                            staffReportVC.viewModel.selectedTime.accept(date)
//                        }
//                    }
//                }
                break
            case .ACTION_MANAGER:
//                if let managerConfirmVC = topVC as? ManagerConfirmVC {
//                    managerConfirmVC.viewModel.selectedProjectID = projectID
//                    if planDate.count > 0 {
//                        if let date = planDate.toDate("yyyy-MM-dd", region: PDefined.serverRegion)?.date {
//                            managerConfirmVC.viewModel.selectedTime.accept(date)
//                        }
//                    }
//                }
                break
            default:
                break
            }
            return
        }
        
        self.handleAction(notificationType, projectID: projectID, planDate: planDate)
    }
    
    func handleSlientPushNotification(content: [AnyHashable : Any]) {
        let actionID = JSON(content)["custom"]["a"]["action_id"].intValue
        let projectID = JSON(content)["custom"]["a"]["project_id"].intValue
        let planDate = JSON(content)["custom"]["a"]["plan_date"].stringValue
        let notificationType = RemoteNotificationType(rawValue: actionID) ?? .UNKNOWN
        
        switch notificationType {
        case .ACTION_STAFF:
            break
        case .ACTION_MANAGER:
            break
        default:
            break
        }
    }
    
    func tapPushWhenBackgroudMode(_ content: [AnyHashable : Any]) {
        let actionID = JSON(content)["custom"]["a"]["action_id"].intValue
        let projectID = JSON(content)["custom"]["a"]["project_id"].intValue
        let planDate = JSON(content)["custom"]["a"]["plan_date"].stringValue
        let notificationType = RemoteNotificationType(rawValue: actionID) ?? .UNKNOWN
        
        self.handleAction(notificationType, projectID: projectID, planDate: planDate)
    }
    
    func showGLNotificationWith(_ content: [AnyHashable : Any]) {
        let actionID = JSON(content)["custom"]["a"]["action_id"].intValue
        let projectID = JSON(content)["custom"]["a"]["project_id"].intValue
        let planDate = JSON(content)["custom"]["a"]["plan_date"].stringValue
        let notificationType = RemoteNotificationType(rawValue: actionID) ?? .UNKNOWN
        //print("content push: \(content)")
        
        let style = GLNotificationStyle.simpleBanner
        //let aps = JSON(content)["aps"].dictionaryValue
        let title = JSON(content)["aps"]["alert"]["title"].string ?? ""
        let message = JSON(content)["aps"]["alert"]["body"].string ?? ""
        var closeTitle = "Close"
        var detailTitle = "Detail"
        
        JSON(content)["buttons"].array?.forEach({ (json) in
            if json["i"].stringValue == "action_detail" {
                detailTitle = json["n"].string ?? "Detail"
            } else if json["i"].stringValue == "action_close" {
                closeTitle = json["n"].string ?? "Close"
            }
        })
        
        
        if message.count > 0 {
            let notiBar = GLNotificationBar(title: title, message: message, preferredStyle: style) { [weak self] (finished) in
                self?.handleAction(notificationType, projectID: projectID, planDate: planDate)
            }
            
            notiBar.notificationSound("default", ofType: ".caf", vibrate: true)
            
            /*
             if let sound = aps["sound"]?.stringValue, sound.count > 0 {
             notiBar.notificationSound(sound, ofType: ".caf", vibrate: true)
             }
             */
        }
    }
    
    func handleAction(_ notificationType: RemoteNotificationType, projectID: Int = 0, planDate: String = "") {
        //if PAppManager.shared.currentUser.value == nil { return }
        guard let topVC = UIApplication.topVC() else { return }
        switch notificationType {
        case .ACTION_STAFF:
//            if let staffReportVC = topVC as? StaffReportVC {
//                if planDate.count > 0 {
//                    if let date = planDate.toDate("yyyy-MM-dd", region: PDefined.serverRegion)?.date {
//                        staffReportVC.viewModel.selectedTime.accept(date)
//                    }
//                }
//            } else {
//                let staffReportVC = StaffReportVC(planDate)
//                topVC.navigationController?.pushViewController(staffReportVC, animated: true)
//            }
            break
        case .ACTION_MANAGER:
//            if let managerConfirmVC = topVC as? ManagerConfirmVC {
//                managerConfirmVC.viewModel.selectedProjectID = projectID
//                if planDate.count > 0 {
//                    if let date = planDate.toDate("yyyy-MM-dd", region: PDefined.serverRegion)?.date {
//                        managerConfirmVC.viewModel.selectedTime.accept(date)
//                    }
//                }
//            } else {
//                let managerConfirmVC = ManagerConfirmVC(selectedProjectID: projectID, selectedTimeStr: planDate)
//                topVC.navigationController?.pushViewController(managerConfirmVC, animated: true)
//            }
            break
        default:
            break
        }
    }
}

// MARK: - Helper

extension PAppManager {
    
//    func getListNotification() {
//        UserServices().getListNotification(page: 1, params: [:])
//            .asDriver(onErrorJustReturn: (list: [], unreadCount: 0))
//            .drive(onNext: { [weak self] (data) in
//                guard let `self` = self else { return }
//                DispatchQueue.main.async {
//                    PAppManager.shared.unreadCount.accept(data.unreadCount)
//                }
//            })
//            .disposed(by: disposeBag)
//    }
}









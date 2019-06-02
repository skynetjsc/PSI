//
//  MoreNotificationVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/30/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum NotificationType: Int {
    
    static let allValues = [all, onlyFeedback, onlyService, offAll]
    
    case all = 0
    case onlyFeedback = 1
    case onlyService = 2
    case offAll = 3
    
    var name: String {
        switch self {
        case .all:
            return "Tất cả thông báo".localized()
        case .onlyFeedback:
            return "Chỉ khi có thông báo về khuyến mại".localized()
        case .onlyService:
            return "Chỉ khi có thông báo tiến hành dịch vụ".localized()
        case .offAll:
            return "Tắt thông báo".localized()
        }
    }
}

class MoreNotificationVM {
    
    let disposeBag = DisposeBag()
    let commonServices = CommonServices()
    let notificationList = BehaviorRelay<[MoreNotificationCellVM]>(value: [])
    let selectedNotification = BehaviorRelay<NotificationType?>(value: nil)
    
    init() {
        notificationList.accept(NotificationType.allValues.map({ (type) -> MoreNotificationCellVM in
            let cellVM = MoreNotificationCellVM(model: type)
            if type == .all {
                cellVM.isSelected.accept(true)
            }
            return cellVM
        }))
    }
}





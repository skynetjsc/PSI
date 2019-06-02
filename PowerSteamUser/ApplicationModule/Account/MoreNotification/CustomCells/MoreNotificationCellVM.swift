//
//  MoreNotificationCellVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/30/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MoreNotificationCellVM {
    
    let disposeBag = DisposeBag()
    var model: NotificationType!
    
    let title = BehaviorRelay<String>(value: "")
    let isSelected = BehaviorRelay<Bool>(value: false)
    
    init(model: NotificationType) {
        self.model = model
        title.accept(model.name)
    }
}

//
//  PaymentMethodCellVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PaymentMethodCellVM {
    
    let disposeBag = DisposeBag()
    var model: PaymentType!
    let isSelected = BehaviorRelay<Bool>(value: false)
    
    init(model: PaymentType) {
        self.model = model
        
    }
}

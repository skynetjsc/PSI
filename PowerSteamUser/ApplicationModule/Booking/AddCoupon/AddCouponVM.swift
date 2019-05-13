//
//  AddCouponVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AddCouponVM {
    
    let disposeBag = DisposeBag()
    var userServices = UserServices()
    let couponStr = BehaviorRelay<String>(value: "")
    let enableConfirm = BehaviorRelay<Bool>(value: false)
    
    init() {
        couponStr.asDriver().map { $0.count > 0 }
            .drive(enableConfirm)
            .disposed(by: disposeBag)
    }
}

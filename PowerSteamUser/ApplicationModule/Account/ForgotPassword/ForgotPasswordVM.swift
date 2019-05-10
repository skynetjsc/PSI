//
//  ForgotPasswordVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ForgotPasswordVM {
    
    let disposeBag = DisposeBag()
    var userServices = UserServices()
    let phoneStr = BehaviorRelay<String>(value: "")
    let enableConfirm = BehaviorRelay<Bool>(value: false)
    
    init() {
        phoneStr.asDriver().map { $0.count > 0 }
            .drive(enableConfirm)
            .disposed(by: disposeBag)
    }
}

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
    
    func forgetPassword(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["phone": phoneStr.value,
                                     "type": 1 // type: 1: user, 2: tech
                                    ]
        
        userServices.forgetPassword(params: params).asObservable()
            .subscribe { (event) in
                PLoadingActivity.shared.hide()
                switch event {
                case .next(let message):
                    //completion?(1, "Send new password successfully".localized())
                    completion?(1, message.count > 0 ? message : "Send new password successfully".localized())
                case .error(let error):
                    if case APIError.error(let error) = error {
                        completion?(0, error.data as? String ?? "Send new password failed".localized())
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

//
//  SignupOtpVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SignupOtpVM {
    
    let disposeBag = DisposeBag()
    var userServices = UserServices()
    var otpCode: Int = 0
    var phoneNumber: String = ""
    var params: [String: Any] = [:] // the dictionay contains inpunts in register vc
    let enableConfirm = BehaviorRelay<Bool>(value: false)
    
    
    init(_ otpCode: Int, _ phoneNumber: String, _ params: [String: Any]) {
        self.otpCode = otpCode
        self.phoneNumber = phoneNumber
        self.params = params
    }
    
    func verifyCode(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["phone": phoneNumber,
                                     "type": 1 // type: 1: user, 2: tech
        ]
        
        userServices.verifyCode(params: params).asObservable()
            .subscribe { (event) in
                PLoadingActivity.shared.hide()
                switch event {
                case .next(let code):
                    self.otpCode = code
                    
                    completion?(1, "Verify code successfully".localized())
                case .error(let error):
                    if case APIError.error(let error) = error {
                        completion?(0, error.data as? String ?? "Verify code failed".localized())
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func register(pinCode: String, completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        params["password"] = pinCode
        userServices.register(params: params).asObservable()
            .subscribe { (event) in
                PLoadingActivity.shared.hide()
                switch event {
                case .next(let userModel):
                    PAppManager.shared.accessToken = userModel.name
                    PAppManager.shared.currentUser = userModel
                    
                    completion?(1, "Register successfully".localized())
                case .error(let error):
                    if case APIError.error(let error) = error {
                        completion?(0, error.data as? String ?? "Register failed".localized())
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

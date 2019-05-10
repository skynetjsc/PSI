//
//  RegisterVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterVM {
    
    let disposeBag = DisposeBag()
    var userServices = UserServices()
    let nameStr = BehaviorRelay<String>(value: "")
    let phoneStr = BehaviorRelay<String>(value: "")
    let emailStr = BehaviorRelay<String>(value: "")
    let enableRegister = BehaviorRelay<Bool>(value: false)
    
    init() {
        
    }
    
//    func register(completion: ((Int, String) -> Void)?) {
//        PLoadingActivity.shared.show()
//        let params: [String: Any] = ["username": accountStr.value, "password": passwordStr.value]
//        userServices.login(params: params).asObservable()
//            .subscribe { (event) in
//                PLoadingActivity.shared.hide()
//                switch event {
//                case .next(let userModel):
//                    PAppManager.shared.accessToken = userModel.token
//                    PAppManager.shared.currentUser = userModel
//                    
//                    completion?(1, "Login successfully".localized())
//                case .error(let error):
//                    if case APIError.error(let error) = error {
//                        completion?(0, error.data as? String ?? "Login failed".localized())
//                    }
//                default:
//                    break
//                }
//            }
//            .disposed(by: disposeBag)
//    }
}

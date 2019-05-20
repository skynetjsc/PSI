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
    var otpCode: Int = 0
    
    init() {
        let validObserable = Observable.combineLatest([nameStr.asObservable(), phoneStr.asObservable(), emailStr.asObservable()]) { [weak self] (list) -> Bool in
            //guard let `self` = self else { return false}
            var result = true
            list.forEach({ (item) in
                if item.isEmpty {
                    result = false
                }
            })
            
            return result
        }
        validObserable.asDriver(onErrorJustReturn: false)
            .drive(self.enableRegister)
            .disposed(by: disposeBag)
    }
    
    func verifyCode(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["phone": phoneStr.value,
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
    
    func getInputParams() -> [String: Any] {
        return ["name": nameStr.value,
                "phone": phoneStr.value,
                "email": emailStr.value]
    }
}







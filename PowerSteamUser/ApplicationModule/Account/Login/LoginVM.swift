//
//  LoginVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LoginVM {
    
    let disposeBag = DisposeBag()
    var userServices = UserServices()
    let accountStr = BehaviorRelay<String>(value: "")
    let passwordStr = BehaviorRelay<String>(value: "")
    let enableLogin = BehaviorRelay<Bool>(value: false)
    
    init() {
        let validObserable = Observable.combineLatest([accountStr.asObservable(), passwordStr.asObservable()]) { [weak self] (list) -> Bool in
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
            .drive(self.enableLogin)
            .disposed(by: disposeBag)
    }
    
    func login(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["phone": accountStr.value,
                                     "password": passwordStr.value,
                                     "type": 1  // type: 1: user, 2: tech
                                    ]
        userServices.login(params: params).asObservable()
            .subscribe { (event) in
                PLoadingActivity.shared.hide()
                switch event {
                case .next(let userModel):
                    PAppManager.shared.accessToken = userModel.name
                    PAppManager.shared.currentUser = userModel
                    
                    completion?(1, "Đăng nhập thành công".localized())
                case .error(let error):
                    if case APIError.error(let error) = error {
                        completion?(0, error.data as? String ?? "Đăng nhập thất bại".localized())
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}






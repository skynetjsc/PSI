//
//  ProfileVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/15/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ProfileVM {
    
    let disposeBag = DisposeBag()
    var userServices = UserServices()
    let avatarLink = BehaviorRelay<String>(value: "")
    let nameStr = BehaviorRelay<String>(value: "")
    let birthdayStr = BehaviorRelay<String>(value: "")
    let phoneStr = BehaviorRelay<String>(value: "")
    let addressStr = BehaviorRelay<String>(value: "")
    let paymentStr = BehaviorRelay<String>(value: "")
    let notificationStr = BehaviorRelay<String>(value: "")
    
    init() {
        if let userModel = PAppManager.shared.currentUser {
            fillData(user: userModel)
        } 
        getInfor()
    }
    
    func getInfor() {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["id": PAppManager.shared.currentUser?.id ?? 0,
                                     "type": 1]
        userServices.getInfo(params: params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                switch event {
                case .next(let userModel):
                    PAppManager.shared.currentUser = userModel
                    self?.fillData(user: userModel)
                case .error(let error):
                    if case APIError.error(let error) = error {
                        print("get info error: \(error.data as? String)")
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fillData(user: PUserModel) {
        avatarLink.accept(user.avatar)
        nameStr.accept(user.name)
        birthdayStr.accept(user.birthdayDate.toFormat("dd/MM/yyyy"))
        phoneStr.accept(user.phone + " (đã xác thực)")
        addressStr.accept(user.address)
        paymentStr.accept("Tiền mặt")
        notificationStr.accept("Tất cả thông báo")
    }
}




//
//  HomeVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HomeVM {
    
    let disposeBag = DisposeBag()
    var userServices = UserServices()
    let nameStr = BehaviorRelay<String>(value: "")
    let phoneStr = BehaviorRelay<String>(value: "")
    let emailStr = BehaviorRelay<String>(value: "")
    let enableRegister = BehaviorRelay<Bool>(value: false)
    
    init() {
        
    }
}

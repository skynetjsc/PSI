//
//  ServiceListCellVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ServiceListCellVM {
    
    let disposeBag = DisposeBag()
    var model: PServiceModel!
    let imageLink = BehaviorRelay<String>(value: "")
    let nameStr = BehaviorRelay<String>(value: "")
    let description = BehaviorRelay<String>(value: "")
    
    init(model: PServiceModel) {
        self.model = model
        
        imageLink.accept(model.img)
        nameStr.accept(model.name)
        description.accept(model.content)
        
        //dummyData()
    }
    
    func dummyData() {
        nameStr.accept("Ngoại thất")
        description.accept("Vệ sinh ngoại thất xe theo các gói dịch vụ do lựa chọn của bạn.")
    }
}

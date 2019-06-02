//
//  CouponCellVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CouponCellVM {
    
    let disposeBag = DisposeBag()
    var model: PPromotionModel!
    
    let timeStr = BehaviorRelay<String>(value: "")
    let titleStr = BehaviorRelay<String>(value: "")
    let contentStr = BehaviorRelay<String>(value: "")
    let isRead = BehaviorRelay<Bool>(value: false)
    
    init(model: PPromotionModel) {
        self.model = model
        
        timeStr.accept(model.dateStart)
        titleStr.accept(model.title)
        contentStr.accept(model.content)
        isRead.accept(model.isRead > 0)
    }
}






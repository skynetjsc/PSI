//
//  ServiceHistoryCellVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/22/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ServiceHistoryCellVM {
    
    let disposeBag = DisposeBag()
    var model: PBookModel!
    
    let imageLink = BehaviorRelay<String>(value: "")
    let nameStr = BehaviorRelay<String>(value: "")
    let timeStr = BehaviorRelay<String>(value: "")
    let priceStr = BehaviorRelay<String>(value: "")
    let statusStr = BehaviorRelay<String>(value: "")
    let statusColor = BehaviorRelay<UIColor>(value: PDefined.mainColor)
    
    init(model: PBookModel) {
        self.model = model
        
        imageLink.accept(model.serviceImage)
        nameStr.accept(model.serviceName)
        timeStr.accept(model.dateWorking)
        priceStr.accept(model.price.currencyVN)
        let bookActiveType = BookActiveType(rawValue: model.active) ?? .notAssign
        statusStr.accept(bookActiveType.name)
        statusColor.accept(bookActiveType.color)
    }
}

//
//  PeriodServiceCellVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/25/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PeriodServiceCellVM {
    
    let disposeBag = DisposeBag()
    var model: PBookModel!
    
    let titleStr = BehaviorRelay<String>(value: "")
    let timeStr = BehaviorRelay<String>(value: "")
    let addressStr = BehaviorRelay<String>(value: "")
    let statusStr = BehaviorRelay<String>(value: "")
    let statusColor = BehaviorRelay<UIColor>(value: PDefined.mainColor)
    
    init(model: PBookModel) {
        self.model = model
        
        titleStr.accept(model.repeatTypeEnum.scheduleName)
        switch model.repeatTypeEnum {
        case .none, .day:
            timeStr.accept("Thực hiện vào \(model.hourWorking) - \(model.repeatTypeEnum.scheduleName)")
        case .week:
            timeStr.accept("Thực hiện vào \(model.hourWorking) - \(model.dayString) - \(model.repeatTypeEnum.scheduleName)")
        case .month:
            timeStr.accept("Thực hiện vào \(model.hourWorking) - \(model.repeatTypeEnum.scheduleName)")
        }
        
        addressStr.accept(model.address)
        let bookActiveType = BookActiveType(rawValue: model.active) ?? .notAssign
        statusStr.accept(bookActiveType.name)
        statusColor.accept(bookActiveType.color)
    }
}

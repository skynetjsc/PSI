//
//  FeedbackCellVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FeedbackCellVM {
    
    let disposeBag = DisposeBag()
    var model: PFeedbackModel!
    
    let timeStr = BehaviorRelay<String>(value: "")
    let titleStr = BehaviorRelay<String>(value: "")
    let addressStr = BehaviorRelay<String>(value: "")
    let status = BehaviorRelay<Int>(value: 0) // 0: waiting, 1: Resolved
    
    init(_ model: PFeedbackModel) {
        self.model = model
        
        timeStr.accept(model.dateCreateDate.toFormat("dd-MM-yyyy, HH:mm"))
        titleStr.accept(model.typeFeedback.count > 0 ? model.typeFeedback : "Yêu cầu bồi thường".localized())
        addressStr.accept(model.address)
        status.accept(model.response.count > 0 ? 1 : 0)
    }
}

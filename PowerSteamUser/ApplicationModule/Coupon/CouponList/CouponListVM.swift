//
//  CouponListVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class CouponListVM {
    
    let disposeBag = DisposeBag()
    let commonServices = CommonServices()
    
    let couponList = BehaviorRelay<[CouponCellVM]>(value: [])
    let hasNoRead = BehaviorRelay<Bool>(value: false)
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    var isFirstLoad = true
    
    init() {
        getPromotionList()
    }
    
    func getPromotionList() {
        if isFirstLoad {
            isFirstLoad = false
            PLoadingActivity.shared.show()
        }
        let params: [String: Any] = ["user_id": PAppManager.shared.currentUser?.id ?? 0,
                                     "type": 1]
        commonServices.getPromotionList(params: params)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (list) in
                PLoadingActivity.shared.hide()
                guard let `self` = self else { return }
                self.shouldShowIndicatorView.accept(false)
                let newList = list.map({ (promotion) -> CouponCellVM in
                    if self.hasNoRead.value == false && promotion.isRead == 0 {
                        self.hasNoRead.accept(true)
                    }
                    return CouponCellVM(model: promotion)
                })
                self.noDataStr.accept(newList.count == 0 ? "Không có dữ liệu".localized() : "")
                self.couponList.accept(newList)
            })
            .disposed(by: disposeBag)
    }
}




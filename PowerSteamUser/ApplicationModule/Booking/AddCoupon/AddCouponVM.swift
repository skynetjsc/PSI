//
//  AddCouponVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AddCouponVM {
    
    let disposeBag = DisposeBag()
    var commonServices = CommonServices()
    let couponStr = BehaviorRelay<String>(value: "")
    let enableConfirm = BehaviorRelay<Bool>(value: false)
    
    init() {
        couponStr.asDriver().map { $0.count > 0 }
            .drive(enableConfirm)
            .disposed(by: disposeBag)
    }
    
    func getPromotionDetail(_ promotionCode: String, completion: ((Int, Any) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["user_id": PAppManager.shared.currentUser?.id ?? 0,
                                     "promotion_id": promotionCode,
                                     "type": 2]
        commonServices.getPromotionDetail(params: params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                guard let self = self else { return }
                switch event {
                case .next(let promotionModel):
                    completion?(1, promotionModel)
                case .error(let error):
                    if case APIError.error(let error) = error {
                        completion?(0, error.data as? String ?? "Mã giảm giá không đúng, vui lòng nhập mã khác!".localized())
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

//
//  CouponDetailVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CouponDetailVM {
    
    let disposeBag = DisposeBag()
    let commonServices = CommonServices()
    var promotionModel: PPromotionModel!
    
    let timeStr = BehaviorRelay<String>(value: "")
    let titleStr = BehaviorRelay<String>(value: "")
    let contentStr = BehaviorRelay<String>(value: "")
    let codeStr = BehaviorRelay<String>(value: "")
    let isRead = BehaviorRelay<Bool>(value: false)
    
    init(_ promotionModel: PPromotionModel) {
        self.promotionModel = promotionModel
        fillData(promotionModel)
    }
    
    func getPromotionDetail(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["user_id": PAppManager.shared.currentUser?.id ?? 0,
                                     "promotion_id": self.promotionModel.id,
                                     "type": 1]
        commonServices.getPromotionDetail(params: params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                guard let self = self else { return }
                switch event {
                case .next(let promotionModel):
                    self.promotionModel = promotionModel
                    self.fillData(promotionModel)
                    completion?(1, "")
                case .error(let error):
                    if case APIError.error(let error) = error {
                        completion?(0, error.data as? String ?? "Có lỗi xảy ra, vui lòng thực hiện lại!".localized())
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
    
    func fillData(_ model: PPromotionModel) {
        timeStr.accept(model.dateStart)
        titleStr.accept(model.title)
        contentStr.accept(model.content)
        codeStr.accept(model.code)
        isRead.accept(model.isRead > 0)
    }
}





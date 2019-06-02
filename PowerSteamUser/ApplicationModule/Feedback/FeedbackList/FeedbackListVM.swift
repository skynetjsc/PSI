//
//  FeedbackListVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class FeedbackListVM {
    
    let disposeBag = DisposeBag()
    let commonServices = CommonServices()
    
    let feedbackList = BehaviorRelay<[FeedbackCellVM]>(value: [])
    let hasNoRead = BehaviorRelay<Bool>(value: false)
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    var isFirstLoad = true
    
    init() {
        getFeedbackList()
    }
    
    func getFeedbackList() {
        if isFirstLoad {
            isFirstLoad = false
            PLoadingActivity.shared.show()
        }
        let params: [String: Any] = ["user_id": PAppManager.shared.currentUser?.id ?? 0]
        commonServices.getFeedbackList(params: params)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (list) in
                PLoadingActivity.shared.hide()
                guard let `self` = self else { return }
                self.shouldShowIndicatorView.accept(false)
                let newList = list.map { FeedbackCellVM($0) }
                self.noDataStr.accept(newList.count == 0 ? "Không có dữ liệu".localized() : "")
                self.feedbackList.accept(newList)
            })
            .disposed(by: disposeBag)
    }
}

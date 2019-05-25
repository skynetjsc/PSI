//
//  ServiceHistoryVM.swift
//  PowerSteamUser
//
//  Created by Mac Mini on 5/22/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class ServiceHistoryVM {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    
    let bookList = BehaviorRelay<[ServiceHistoryCellVM]>(value: [])
    var typeHistory: Int = 3 // 1: đang chờ, 2: đã hoàn thành, 3: tất cả
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    var isFirstLoad = true
    
    init() {
        getServiceHistory()
    }
    
    func getServiceHistory() {
        if isFirstLoad {
            isFirstLoad = false
            PLoadingActivity.shared.show()
        }
        let params: [String: Any] = ["id": PAppManager.shared.currentUser?.id ?? 0,
                                     "type": 1,
                                     "type_history": typeHistory]
        bookingServices.getServiceHistory(params: params)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (list) in
                PLoadingActivity.shared.hide()
                guard let `self` = self else { return }
                self.shouldShowIndicatorView.accept(false)
                let newList = list.map { ServiceHistoryCellVM(model: $0) }
                self.noDataStr.accept(newList.count == 0 ? "Không có dữ liệu".localized() : "")
                self.bookList.accept(newList)
            })
            .disposed(by: disposeBag)
    }
}

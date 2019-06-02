//
//  PeriodServiceVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/25/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class PeriodServiceVM {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    
    let bookList = BehaviorRelay<[PeriodServiceCellVM]>(value: [])
    var typeHistory: Int = 1 // 1: hang ngay, 2: hang tuan, 3: hang thang
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    var isFirstLoad = true
    
    init() {
        getSchedule()
    }
    
    func getSchedule() {
        if isFirstLoad {
            isFirstLoad = false
            PLoadingActivity.shared.show()
        }
        let params: [String: Any] = ["id": PAppManager.shared.currentUser?.id ?? 0,
                                     "type": 1,
                                     "type_history": typeHistory]
        bookingServices.getSchedule(params: params)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (list) in
                PLoadingActivity.shared.hide()
                guard let `self` = self else { return }
                self.shouldShowIndicatorView.accept(false)
                let newList = list.map { PeriodServiceCellVM(model: $0) }
                self.noDataStr.accept(newList.count == 0 ? "Không có dữ liệu".localized() : "")
                self.bookList.accept(newList)
            })
            .disposed(by: disposeBag)
    }
    
    func dummayData() {
        noDataStr.accept("")
        bookList.accept((1...10).map { _ in PeriodServiceCellVM(model: PBookModel()) })
    }
}




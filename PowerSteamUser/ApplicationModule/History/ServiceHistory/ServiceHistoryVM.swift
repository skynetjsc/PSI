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
    
    let serviceList = BehaviorRelay<[ServiceListCellVM]>(value: [])
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    
    init() {
        getServiceList()
    }
    
    func getServiceList() {
        PLoadingActivity.shared.show()
        bookingServices.getServiceList(params: [:])
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (list) in
                PLoadingActivity.shared.hide()
                guard let `self` = self else { return }
                self.shouldShowIndicatorView.accept(false)
                let newList = list.map { ServiceListCellVM(model: $0) }
                self.noDataStr.accept(newList.count == 0 ? "Không có dữ liệu".localized() : "")
                self.serviceList.accept(newList)
            })
            .disposed(by: disposeBag)
    }
}

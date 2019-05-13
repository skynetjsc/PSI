//
//  ServiceListVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ServiceListVM {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    
    let serviceList = BehaviorRelay<[ServiceListCellVM]>(value: [])
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    
    init() {
        dummyData()
        //getServiceList()
    }
    
    func getServiceList() {
        bookingServices.getServiceList(params: [:])
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (list) in
                guard let `self` = self else { return }
                self.shouldShowIndicatorView.accept(false)
                let newList = list.map { ServiceListCellVM(model: $0) }
                self.noDataStr.accept(newList.count == 0 ? "Không có dữ liệu".localized() : "")
                self.serviceList.accept(newList)
            })
            .disposed(by: disposeBag)
    }
    
    func dummyData() {
        shouldShowIndicatorView.accept(false)
        serviceList.accept((1...5).map { _ in ServiceListCellVM(model: PServiceModel()) })
    }
}






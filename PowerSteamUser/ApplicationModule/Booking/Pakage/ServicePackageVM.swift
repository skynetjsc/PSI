//
//  ServicePackageVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import CoreLocation
import RxCocoa
import RxSwift

class ServicePackageVM {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    var address: String = ""
    var location: CLLocation!
    var typeBike: Int = 0
    var locationID: Int = 0
    var serviceModel: PServiceModel!
    var selectedPromotionID: Int = 0
    
    let packageList = BehaviorRelay<[PackageCellVM]>(value: [])
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    let selectedPackage = BehaviorRelay<PServicePackageModel?>(value: nil)
    let addressStr = BehaviorRelay<String>(value: "")
    let packageNameStr = BehaviorRelay<String>(value: "")
    let packagePriceStr = BehaviorRelay<String>(value: "")
    let enableConfirm = BehaviorRelay<Bool>(value: false)
    let hourWorking = BehaviorRelay<String>(value: "")
    let dateWorking = BehaviorRelay<Date>(value: Date())
    let repeatType = BehaviorRelay<RepeatType>(value: .none)
    
    init(_ address: String, _ location: CLLocation, _ typeBike: Int, _ locationID: Int = 0, _ serviceModel: PServiceModel) {
        self.address = address
        self.location = location
        self.typeBike = typeBike
        self.locationID = locationID
        self.serviceModel = serviceModel
        
        addressStr.accept(address)
        
        getServiceCategory()
        
        let validObserable = Observable.combineLatest(selectedPackage.asObservable(), hourWorking.asObservable(), dateWorking.asObservable()) { (value1, value2, value3) -> Bool in
            return value1 != nil && value2.count > 0 && value3 != nil
        }
        validObserable.asDriver(onErrorJustReturn: false)
            .drive(self.enableConfirm)
            .disposed(by: disposeBag)
    }
    
    func getServiceCategory() {
        PLoadingActivity.shared.show()
        bookingServices.getServiceCategory(params: ["category_id": serviceModel.id])
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (list) in
                PLoadingActivity.shared.hide()
                guard let `self` = self else { return }
                self.shouldShowIndicatorView.accept(false)
                let newList = list.map { PackageCellVM(model: $0) }
                self.noDataStr.accept(newList.count == 0 ? "Không có dữ liệu".localized() : "")
                self.packageList.accept(newList)
            })
            .disposed(by: disposeBag)
    }
}

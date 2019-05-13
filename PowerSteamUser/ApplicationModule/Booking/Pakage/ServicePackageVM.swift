//
//  ServicePackageVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ServicePackageVM {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    var serviceModel: PServiceModel!
    
    var servicePackageModel: PServicePackageModel!
    let packageList = BehaviorRelay<[PackageCellVM]>(value: [])
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    
    init(_ serviceModel: PServiceModel) {
        self.serviceModel = serviceModel
        getServiceCategory()
    }
    
    func getServiceCategory() {
        PLoadingActivity.shared.show()
        bookingServices.getServiceCategory(params: ["category_id": 1])
            .asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                self?.shouldShowIndicatorView.accept(false)
                self?.packageList.accept((1...4).map { _ in PackageCellVM(model: PPackageModel()) })
                guard let `self` = self else { return }
                switch event {
                case .next(let servicePackageModel):
                    self.servicePackageModel = servicePackageModel
                case .error(let error):
                    if case APIError.error(let error) = error {
                        self.noDataStr.accept(error.data as? String ?? "Có lỗi xảy ra, vui lòng thử lại".localized())
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}

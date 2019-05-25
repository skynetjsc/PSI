//
//  BookSuccessViewModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BookSuccessViewModel {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    var bookModel: PBookModel!
    
    let techAvararLink = BehaviorRelay<String>(value: "")
    let techName = BehaviorRelay<String>(value: "")
    let techRate = BehaviorRelay<String>(value: "")
    let timeStr = BehaviorRelay<String>(value: "")
    let priceStr = BehaviorRelay<String>(value: "")
    
    let rating = BehaviorRelay<Int>(value: 0)
    let enableConfirm = BehaviorRelay<Bool>(value: false)
    
    init(_ bookModel: PBookModel) {
        self.bookModel = bookModel
        
        if let tech = bookModel.tech {
            techAvararLink.accept(tech.avatar)
            techName.accept(tech.name)
            techRate.accept("\(tech.rating)")
        }
        
        timeStr.accept(bookModel.timeWorking)
        priceStr.accept(bookModel.price.currencyVN)
        rating.asDriver().map { $0 > 0 }.drive(self.enableConfirm).disposed(by: disposeBag)
    }
    
    func rating(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["user_id": PAppManager.shared.currentUser?.id ?? 0,
                                     "booking_id": bookModel.bookingID,
                                     "star": rating.value]
        
        bookingServices.rating(params: params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                guard let self = self else { return }
                switch event {
                case .next(let message):
                    completion?(1, message)
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
}

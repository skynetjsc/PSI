//
//  SearchingTechVM.swift
//  PowerSteamUser
//
//  Created by Mac Mini on 5/22/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SearchingTechVM {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    var bookingID: Int = 0
    
    init(_ bookingID: Int) {
        self.bookingID = bookingID
    }
    
    func cancelBooking(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["id": self.bookingID,
                                     "active": 5]
        
        bookingServices.updateStatusBooking(params: params).asObservable()
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

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
    var bookModel: PBookModel!
    
    init(_ bookModel: PBookModel) {
        self.bookModel = bookModel
    }
    
    func cancelBooking(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["id": bookModel.bookingID,
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
    
    func getBookingDetail(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["id": bookModel.bookingID]
        bookingServices.bookingDetail(params: params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                guard let self = self else { return }
                switch event {
                case .next(let bookModel):
                    self.bookModel = bookModel
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
}

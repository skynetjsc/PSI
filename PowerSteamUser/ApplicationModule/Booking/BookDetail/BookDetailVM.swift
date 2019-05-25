//
//  BookDetailVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/24/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BookDetailVM {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    var bookingID: Int = 0
    var bookModel: PBookModel!
    
    let timeStr = BehaviorRelay<String>(value: "")
    let serviceImageLink = BehaviorRelay<String>(value: "")
    let serviceName = BehaviorRelay<String>(value: "")
    let servicePrice = BehaviorRelay<String>(value: "")
    let bookingIDStr = BehaviorRelay<String>(value: "")
    let bookActiveType = BehaviorRelay<BookActiveType>(value: .completed)
    let techAvararLink = BehaviorRelay<String>(value: "")
    let techName = BehaviorRelay<String>(value: "")
    let techRate = BehaviorRelay<String>(value: "")
    let isHiddenTech = BehaviorRelay<Bool>(value: false)
    let addressStr = BehaviorRelay<String>(value: "")
    let imageLinks = BehaviorRelay<[String]>(value: [])
    let isHiddenImages = BehaviorRelay<Bool>(value: false)
    let serviceItems = BehaviorRelay<[PPackageItemModel]>(value: [])
    
    init(_ bookingID: Int) {
        self.bookingID = bookingID
    }
    
    func getBookingDetail(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["id": bookingID]
        bookingServices.bookingDetail(params: params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                guard let self = self else { return }
                switch event {
                case .next(let bookModel):
                    self.bookModel = bookModel
                    self.fillData(bookModel)
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
    
    func fillData(_ bookModel: PBookModel) {
        if let tech = bookModel.tech {
            techAvararLink.accept(tech.avatar)
            techName.accept(tech.name)
            techRate.accept("\(tech.rating)")
        }
        isHiddenTech.accept(bookModel.tech?.id == 0)
        timeStr.accept(bookModel.dateCreate)
        serviceImageLink.accept(bookModel.serviceImage)
        serviceName.accept(bookModel.serviceName)
        servicePrice.accept(bookModel.price.currencyVN)
        bookingIDStr.accept("#PSI\(bookModel.bookingID)")
        bookActiveType.accept(bookModel.bookActiveType)
        serviceItems.accept(bookModel.serviceItems)
        addressStr.accept(bookModel.address)
        imageLinks.accept(bookModel.listImage)
        isHiddenImages.accept(bookModel.listImage.count == 0)
    }
}







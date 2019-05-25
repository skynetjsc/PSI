//
//  BookOnWayViewModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BookOnWayViewModel {
    
    let disposeBag = DisposeBag()
    var bookModel: PBookModel!
    
    let statusStr = BehaviorRelay<String>(value: "")
    let timeStr = BehaviorRelay<String>(value: "")
    let techAvararLink = BehaviorRelay<String>(value: "")
    let techName = BehaviorRelay<String>(value: "")
    let rateStr = BehaviorRelay<String>(value: "")
    
    let serviceImageLink = BehaviorRelay<String>(value: "")
    let serviceName = BehaviorRelay<String>(value: "")
    let servicePrice = BehaviorRelay<String>(value: "")
    let paymentType = BehaviorRelay<PaymentType>(value: .cash)
    let vehicleType = BehaviorRelay<VehicleType>(value: .bike)
    
    init(_ bookModel: PBookModel) {
        self.bookModel = bookModel
        
        if let tech = bookModel.tech {
            techAvararLink.accept(tech.avatar)
            techName.accept(tech.name)
            rateStr.accept("\(tech.rating)")
        }
        
        statusStr.accept(bookModel.bookActiveType.name)
        serviceImageLink.accept(bookModel.serviceImage)
        serviceName.accept(bookModel.serviceName)
        servicePrice.accept(bookModel.price.currencyVN)
        paymentType.accept(bookModel.paymentType)
        vehicleType.accept(bookModel.vehicleType)
    }
}

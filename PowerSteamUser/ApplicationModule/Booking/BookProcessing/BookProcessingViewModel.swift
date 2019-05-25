//
//  BookProcessingViewModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BookProcessingViewModel {
    
    let disposeBag = DisposeBag()
    var bookModel: PBookModel!
    
    let timeStr = BehaviorRelay<String>(value: "")
    let techAvararLink = BehaviorRelay<String>(value: "")
    let techName = BehaviorRelay<String>(value: "")
    let rateStr = BehaviorRelay<String>(value: "")
    
    let serviceImageLink = BehaviorRelay<String>(value: "")
    let serviceName = BehaviorRelay<String>(value: "")
    let promotionStr = BehaviorRelay<String>(value: "")
    let serviceItems = BehaviorRelay<[PPackageItemModel]>(value: [])
    let paymentStr = BehaviorRelay<String>(value: "")
    
    init(_ bookModel: PBookModel) {
        self.bookModel = bookModel
        
        timeStr.accept(bookModel.hourWorking)
        if let tech = bookModel.tech {
            techAvararLink.accept(tech.avatar)
            techName.accept(tech.name)
            rateStr.accept("\(tech.rating)")
        }
        
        serviceImageLink.accept(bookModel.serviceImage)
        serviceName.accept(bookModel.serviceName)
        promotionStr.accept(bookModel.promotionValue > 0 ? bookModel.promotionValue.description : "")
        serviceItems.accept(bookModel.serviceItems)
        paymentStr.accept(bookModel.paymentType.shortName)
    }
}

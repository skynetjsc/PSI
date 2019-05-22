//
//  PaymentVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum PaymentType: Int {
    
    static let allValues = [myWallet, visa, cash]
    
    case cash = 1
    case visa = 2
    case myWallet = 3
    
    var name: String {
        switch self {
        case .myWallet:
            return "Ví tài khoản của tôi".localized()
        case .visa:
            return "Thẻ VISA".localized()
        case .cash:
            return "Tiền mặt(Cash)".localized()
        }
    }
}

class PaymentVM {
    
    let disposeBag = DisposeBag()
    let bookingServices = BookingServices()
    var params: [String: Any] = [:]
    
    let paymentList = BehaviorRelay<[PaymentMethodCellVM]>(value: [])
    let selectedPayment = BehaviorRelay<PaymentType?>(value: nil)
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    let enableConfirm = BehaviorRelay<Bool>(value: false)
    
    init(_ params: [String: Any]) {
        self.params = params
        //dummyData()
        paymentList.accept(PaymentType.allValues.map({ (type) -> PaymentMethodCellVM in
            let cellVM = PaymentMethodCellVM(model: type)
            if type == .cash {
                cellVM.isSelected.accept(true)
                self.selectedPayment.accept(.cash)
            }
            return cellVM
        }))
        
        selectedPayment.asDriver().map { $0 != nil }.drive(self.enableConfirm).disposed(by: disposeBag)
    }
    
    func booking(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        self.params["method_payment"] = (self.selectedPayment.value ?? .cash).rawValue
        
        bookingServices.booking(params: self.params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                guard let self = self else { return }
                switch event {
                case .next(let model):
                    completion?(1, model.bookingID.description)
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
    
    func dummyData() {
        shouldShowIndicatorView.accept(false)
        paymentList.accept((1...5).map { _ in PaymentMethodCellVM(model: .myWallet) })
    }
}

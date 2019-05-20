//
//  TermsVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TermsVM {
    
    let disposeBag = DisposeBag()
    var commomServices = CommonServices()
    var agreementType: AgreementType = .privacy

    let titleStr = BehaviorRelay<String>(value: "Điều khoản & Dịch vụ")
    let contentStr = BehaviorRelay<String>(value: "")
    
    init(_ agreementType: AgreementType) {
        self.agreementType = agreementType
        getTermsAgreement()
    }
    
    func getTermsAgreement() {
        PLoadingActivity.shared.show()
        commomServices.getTermsAgreement(agreementType: self.agreementType).asObservable()
            .subscribe { (event) in
                PLoadingActivity.shared.hide()
                switch event {
                case .next(let model):
                    self.titleStr.accept(model.title)
                    self.contentStr.accept(model.content)
                case .error(let error):
                    if case APIError.error(let error) = error {
                        let message = error.data as? String ?? "Có lỗi xảy ra, vui lòng thử lại!".localized()
                        AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                        self.contentStr.accept(message)
                    }
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }
}





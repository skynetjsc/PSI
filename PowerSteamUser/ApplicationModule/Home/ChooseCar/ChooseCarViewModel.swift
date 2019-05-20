//
//  ChooseCarViewModel.swift
//  PowerSteamUser
//
//  Created by Mac on 5/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ChooseCarViewModel {
    
    let disposeBag = DisposeBag()
    let commonServices = CommonServices()
    
    init() {
        
    }
    
    func addCar(_ type: Int, _ carName: String, completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["user_id": PAppManager.shared.currentUser?.id ?? 0,
                                     "type": type,
                                     "car_name": carName]
        
        commonServices.addCar(params: params).asObservable()
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

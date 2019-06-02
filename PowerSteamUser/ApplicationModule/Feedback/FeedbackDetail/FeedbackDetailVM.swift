//
//  FeedbackDetailVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FeedbackDetailVM {
    
    let disposeBag = DisposeBag()
    let commonServices = CommonServices()
    var feedbackModel: PFeedbackModel!
    
    let timeStr = BehaviorRelay<String>(value: "")
    let typeStr = BehaviorRelay<String>(value: "")
    let contentStr = BehaviorRelay<String>(value: "")
    let reponseStr = BehaviorRelay<String>(value: "")
    
    init(_ feedbackModel: PFeedbackModel) {
        self.feedbackModel = feedbackModel
        fillData(feedbackModel)
    }
    
    func getFeedbackDetail(completion: ((Int, String) -> Void)?) {
        PLoadingActivity.shared.show()
        let params: [String: Any] = ["user_id": PAppManager.shared.currentUser?.id ?? 0,
                                     "feedback_id": self.feedbackModel.id]
        commonServices.getFeedbackDetail(params: params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                guard let self = self else { return }
                switch event {
                case .next(let feedbackModel):
                    self.feedbackModel = feedbackModel
                    self.fillData(feedbackModel)
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
    
    func fillData(_ model: PFeedbackModel) {
        timeStr.accept(model.dateCreateDate.toFormat("dd-MM-yyyy, HH:mm"))
        typeStr.accept(model.typeFeedback.count > 0 ? model.typeFeedback : "Yêu cầu bồi thường".localized())
        contentStr.accept(model.content)
        reponseStr.accept(model.response.count > 0 ? model.response : "PSI đã tiến hành giám định hiện trường và xác minh về khiếu nại của bạn, chúng tôi sẽ liên lạc với bạn trong thời gian sớm nhất.".localized())
    }
}





//
//  NewFeedbackVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class NewFeedbackVM {
    
    let disposeBag = DisposeBag()
    let commonServices = CommonServices()
    
    let time = BehaviorRelay<Date>(value: Date())
    let address = BehaviorRelay<String>(value: "")
    let contentStr = BehaviorRelay<String>(value: "")
    let feedbackType = BehaviorRelay<String>(value: "Yêu cầu bồi thường")
    var selectedImages = [UIImage]()
    
    init() {
        // write code here
    }
    
    func createFeedback(completion: @escaping ((Int, Any) -> Void)) {
        var filesData: [(key: String, value: Data, fileName: String, mimeType: String)] = []
        let userID = PAppManager.shared.currentUser?.id ?? 0
        // add file data
        for item in selectedImages {
            let resizeImage = item.resizeImageFitTo(size: 800)
            if let imageData = resizeImage.jpegData(compressionQuality: 0.7) {
                filesData.append((key: "img[]", value: imageData, fileName: "image_\(userID)_\(Date().timeIntervalSince1970).png", mimeType: "image/png"))
            }
        }
        
        let params: [String: Any] = ["user_id": userID,
                                     "content": contentStr.value,
                                     "address": address.value,
                                     "type_feedback": feedbackType.value,
                                     "time_feedback": time.value.convertTo(region: PDefined.serverRegion).toFormat("yyyy-MM-dd HH:mm:ss")]
        commonServices.sendFeedback(params: params, filesData: filesData)
            .subscribe(onNext: { [weak self] (message) in
                completion(1, message)
                }, onError: { (error) in
                    if case APIError.error(let error) = error {
                        completion(0, error.data as? String ?? "Có lỗi xảy ra, vui lòng thực hiện lại!".localized())
                    }
            })
            .disposed(by: disposeBag)
    }
}




//
//  ConversationVM.swift
//  LianChat
//
//  Created by Mac on 1/15/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ConversationVM {
    
    let disposeBag = DisposeBag()
    let chatService = ChatServices()
    
    let conversationList = BehaviorRelay<[ConversationCellVM]>(value: [])
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let noDataStr = BehaviorRelay<String>(value: "")
    
    init() {
        SocketIOManager.shared.establishConnection()
        self.listConversation()
    }
    
    func listConversation() {
        let params: [String: Any] = ["id": PAppManager.shared.currentUser?.id ?? 0, "type": 1]
        chatService.listConversation(params: params)
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] (list) in
                guard let `self` = self else { return }
                self.shouldShowIndicatorView.accept(false)
                let newList = list.compactMap({ (model) -> ConversationCellVM? in
                    return ConversationCellVM(conversation: model)
                })
                self.conversationList.accept(newList)
                self.noDataStr.accept(newList.count == 0 ? "Không có dữ liệu".localized() : "")
            })
            .disposed(by: disposeBag)
    }
}

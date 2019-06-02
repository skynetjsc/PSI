//
//  ConversationCellVM.swift
//  LianChat
//
//  Created by Mac on 1/16/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ConversationCellVM {
    
    var conversation: PConversationModel!
    
    // Private Type
    let avatarLink = BehaviorRelay<String>(value: "")
    let isOnline = BehaviorRelay<Bool>(value: false)
    
    // Common
    let nameStr = BehaviorRelay<String>(value: "")
    let lastMessage = BehaviorRelay<String>(value: "")
    let timeUpdated = BehaviorRelay<String>(value: "")
    
    init(conversation: PConversationModel) {
        self.conversation = conversation
        
        avatarLink.accept(conversation.tech?.avatar ?? "")
        isOnline.accept(conversation.isOnline)
        nameStr.accept(conversation.tech?.name ?? "")
        lastMessage.accept(conversation.lastMessage)
        timeUpdated.accept(conversation.date)
    }
}

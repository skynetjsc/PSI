//
//  MessageCellVM.swift
//  LianChat
//
//  Created by Mac on 1/17/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftDate

class MessageCellVM {
    
    let disposeBag = DisposeBag()
    var message: PMessageModel!
    
    let userAvatarLink = BehaviorRelay<String>(value: "")
    let techAvatarLink = BehaviorRelay<String>(value: "")
    let imageLink = BehaviorRelay<String>(value: "")
    let isOnline = BehaviorRelay<Bool>(value: false)
    let messageStr = BehaviorRelay<String>(value: "")
    let fileStr = BehaviorRelay<String>(value: "")
    let timeStr = BehaviorRelay<String>(value: "")
    let heroImageID = BehaviorRelay<String?>(value: nil)
    let statusImage = BehaviorRelay<UIImage>(value: #imageLiteral(resourceName: "emoji"))
    let isPlaying = BehaviorRelay<Bool>(value: false)
    
    init(message: PMessageModel, contentMessage: PContentChatModel) {
        self.message = message
        
        userAvatarLink.accept(contentMessage.avatarUser)
        techAvatarLink.accept(contentMessage.avatarTech)
        messageStr.accept(message.content)
        isOnline.accept(message.isOnline)
        if message.timeDate.isToday {
            timeStr.accept(message.timeDate.toFormat("HH:mm"))
        } else {
            timeStr.accept(message.timeDate.toFormat("dd-MM HH:mm"))
        }
    }
}


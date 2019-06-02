//
//  ChatVM.swift
//  LianChat
//
//  Created by Mac on 1/17/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyJSON
import Foundation

class ChatVM {
    
    let disposeBag = DisposeBag()
    let chatServices = ChatServices()
    
    var userID: Int = 0
    var techID: Int = 0
    var bookingID: Int = 0
    
    // Tech
    let techName = BehaviorRelay<String>(value: "")
    
    // Chat
    var contentChat: PContentChatModel!
    let messageList = BehaviorRelay<[MessageCellVM]>(value: [])
    let refreshTableView = PublishSubject<Void>()
    let shouldShowIndicatorView = BehaviorRelay<Bool>(value: true)
    let showNoResultView = BehaviorRelay<Bool>(value: false)
    let page = BehaviorRelay<Int>(value: 0)
    var hasLoadMore = PublishSubject<Bool>()
    
    init(_ userID: Int, _ techID: Int, _ bookingID: Int = 0) {
        self.userID = userID
        self.techID = techID
        
        self.getContentChat()
        self.setupSocketForRoom()
    }
    
    /// get content of chat
    func getContentChat() {
        let params: [String: Any] = ["index": self.page.value,
                                     "user_id": self.userID,
                                     "tech_id": self.techID,
                                     "type": 1]
        PLoadingActivity.shared.show()
        chatServices.contentChat(params: params).asObservable()
            .subscribe { [weak self] (event) in
                PLoadingActivity.shared.hide()
                guard let `self` = self else { return }
                switch event {
                case .next(let content):
                    self.contentChat = content
                    self.techName.accept(content.nameShop)
                    
                    let newList = content.listContent.reversed().map({ (message) -> MessageCellVM in
                        return MessageCellVM(message: message, contentMessage: content)
                    })
                    self.messageList.accept(self.messageList.value + newList)
                    self.shouldShowIndicatorView.accept(false)
                    if self.page.value == 0 {
                        self.showNoResultView.accept(content.listContent.count == 0)
                    }
                    //self.hasLoadMore.onNext(content.listContent.count > 0)
                    //self.page.accept(content.index)
                    self.refreshTableView.onNext(())
                case .error(let error):
                    if case APIError.error(let error) = error {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: error.data as? String ?? "Có lỗi xảy ra, vui lòng thực hiện lại!".localized())
                    }
                default:
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    func sendMessage(text: String, completion: @escaping ((Int, Any) -> Void)) {
        let params: [String: Any] = ["user_id": self.userID,
                                     "tech_id": self.techID,
                                     "id_post": self.bookingID,
                                     "content": text.encodeUrl() ?? "",
                                     "time": Date().convertTo(region: PDefined.serverRegion).toFormat("yyyy-MM-dd HH:mm:ss"),
                                     "type": 1,
                                     "attach": 0]
        
        chatServices.sendMessage(params: params)
            .subscribe(onNext: { (messageModel) in
                completion(1, messageModel)
                SocketIOManager.shared.sendMessage(text: text.encodeUrl() ?? "", sendFrom: self.contentChat.nameUser, idUser: self.userID, idHost: self.techID, idPost: self.bookingID, type: 1)
            }, onError: { (error) in
                if case APIError.error(let error) = error {
                    completion(0, error.data as? String ?? "Có lỗi xảy ra, vui lòng thực hiện lại!".localized())
                }
            })
            .disposed(by: disposeBag)
    }

    
    func setupSocketForRoom() {
        SocketIOManager.shared.newMessage { [weak self] (data) in
            guard let `self` = self else { return }
            /*
             sendFrom: là tên người gửi
             idUser: id user
             idHost: id techh
             idPost: id Booking ( có thể truyền 0 cũng đc vì chưa bắt dữ liệu)
             content: nội dung tin nhắn
             type: 1 (user gửi) / 2 (tech gửi) . key này tốt nhất lấy ở trường type mà api profile trả về.
             */
            for item in JSON(data).arrayValue {
                let bookingID = Int(item["idPost"].stringValue) ?? 0
                let userID = Int(item["idUser"].stringValue) ?? 0
                let techID = Int(item["idHost"].stringValue) ?? 0
                
                if self.bookingID == bookingID && self.userID == userID && self.techID == techID {
                    let messageModel = PMessageModel()
                    messageModel.content = item["content"].stringValue.decodeUrl() ?? ""
                    messageModel.type = item["type"].description
                    messageModel.contentType = "0"
                    messageModel.time = Date().convertTo(region: PDefined.serverRegion).toFormat("yyyy-MM-dd HH:mm:Ss")
                    self.messageList.insert(MessageCellVM(message: messageModel, contentMessage: self.contentChat), at: 0)
                    self.refreshTableView.onNext(())
                }
            }
        }
    }
}

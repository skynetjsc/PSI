//
//  SocketIOManager.swift
//  LianChat
//
//  Created by Mac on 1/19/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import Foundation
import SocketIO
import UIKit

public let kBaseChatURL = "http://45.119.82.138:4001"
//public let kBaseChatURL = Bundle.main.object(forInfoDictionaryKey: "BASE_CHAT_URL") as! String

class SocketIOManager: NSObject {
    
    // Share instance
    static let shared = SocketIOManager()
    let manager = SocketManager(socketURL: URL(string: kBaseChatURL)!, config: [.log(true), .compress])
    let socket: SocketIOClient!
    
    // MARK: - Init
    override init() {
        self.socket = self.manager.defaultSocket
        
        super.init()
    }
    
    // MARK: - Connection func
    
    func establishConnection(_ onConnectedEvent: (() -> Void)? = nil) {
        socket.connect()
        socket.on(clientEvent: .connect) { (data, ack) in
            //print("Connected")
            onConnectedEvent?()
        }
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    // MARK: - Register
    
    // login user to socket to subcribe status on/off
    func login(userID: String) {
        socket.on(clientEvent: .connect) { [weak self] (dataArray, socketAck) in
            //print("Connected")
            self?.socket.emit("lian-login", ["user_id": userID])
        }
    }
    
    func joinRoom(conversationID: String) {
        socket.on(clientEvent: .connect) { [weak self] (dataArray, socketAck) in
            //print("Connected")
            self?.socket.emit("join-room", ["room_id": conversationID])
        }
    }
    
    func leaveRoom(conversationID: String) {
        socket.on(clientEvent: .connect) { [weak self] (dataArray, socketAck) in
            //print("Connected")
            self?.socket.emit("leave-room", ["room_id": conversationID])
        }
    }
    
    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    
    func sendMessage(text: String, sendFrom: String, idUser: Int, idHost: Int, idPost: Int, type: Int) {
         /*
         sendFrom: là tên người gửi
         idUser: id user
         idHost: id techh
         idPost: id Booking ( có thể truyền 0 cũng đc vì chưa bắt dữ liệu)
         content: nội dung tin nhắn
         type: 1 (user gửi) / 2 (tech gửi) . key này tốt nhất lấy ở trường type mà api profile trả về.
         */
        socket.emit("send_psi_chat", ["content": text,
                                  "sendFrom": sendFrom,
                                  "idUser": idUser,
                                  "idHost": idHost,
                                  "idPost": idPost,
                                  "type": type,
                                  "time": Date().convertTo(region: PDefined.serverRegion).toFormat("yyyy-MM-dd HH:mm:ss")])
    }

    func newMessage(completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        // ["server-lian-chat",{"idDestination":"","idOrignal":"3ed572a6-0278-11e9-b7ce-005056b2404b","room_id":"84","message":"Hình ảnh","type":1}]
        socket.on("psi_chat") { (dataArray, socketAck) -> Void in
            //print("New message")
            completionHandler(dataArray)
        }
    }

    func sendStartTypingMessage(nickname: String) {
        socket.emit("startType", nickname)
    }

    func listenForOtherMessages() {
        socket.on("chat") { (dataArray, socketAck) -> Void in
            //print("Chat message")
            //NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNewMessageNotification), object: dataArray)
        }
    }

    // call this api when user into chat room
    func readMessage(conversationID: String, messageID: String, userID: String, userName: String) {
        socket.emit("seen", ["room_id": conversationID,
                             "user_id": userID,
                             "message_id": messageID,
                             "user_name": userName,
                             "time": Date().convertTo(region: PDefined.serverRegion).toFormat("HH:mm dd/MM/yyyy")])
    }
    
    // subscribe event seen message of another user
    func onSeen(completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        socket.on("send-seen") { (dataArray, socketAck) -> Void in
            //print("send-seen")
            completionHandler(dataArray)
        }
    }
    
    func sendBooking(params: [String: Any]) {
        socket.emit("send_psi_booking", params)
    }
    
    func newBooking(completionHandler: @escaping (_ messageInfo: [Any]) -> Void) {
        socket.on("psi_booking") { (dataArray, socketAck) -> Void in
            //print("New message")
            completionHandler(dataArray)
        }
    }
}

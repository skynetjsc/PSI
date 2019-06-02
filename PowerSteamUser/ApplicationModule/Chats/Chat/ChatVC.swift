//
//  ChatVC.swift
//  LianChat
//
//  Created by Mac on 1/17/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import AVKit
import DKImagePickerController
import ISEmojiView
import RxCocoa
import RxSwift
import SnapKit
import SwiftDate
import UIKit

class ChatVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var accessoryView: UIView!
    @IBOutlet weak var chatTextView: KMPlaceholderTextView!
    @IBOutlet weak var accessoryStackView: UIStackView!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var heightChatView: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variable
    private let disposeBag = DisposeBag()
    var viewModel: ChatVM!
    var emojiContainerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 216))
    var emojiView: EmojiView!
    var selectedEmoji = false
    var isFirstLoad = true
    
    init(_ userID: Int, _ techID: Int, _ bookingID: Int = 0) {
        viewModel = ChatVM(userID, techID, bookingID)
        super.init(nibName: "ChatVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initComponent()
        bindData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstLoad {
            isFirstLoad = false
            //chatTextView.becomeFirstResponder()
        }
    }
}

// MARK: - Initialization

extension ChatVC {
    
    private func initComponent() {
        navigationBar.divView.isHidden = false
        
        // indicator view
        viewModel.shouldShowIndicatorView.asDriver()
            .drive(onNext: { [weak self] (isShow) in
                self?.tableView.showIndicatorView(isShow: isShow)
            })
            .disposed(by: disposeBag)
        
        // Tap action
        tapActions()
        addObserverNotification()
        
        chatTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 8)
        chatTextView.textContainer.maximumNumberOfLines = 50
        chatTextView.textContainer.lineBreakMode = .byTruncatingTail
        chatTextView.rx.didChange.subscribe(onNext: { [weak self] n in
            guard let `self` = self else { return }
            
            let height = self.chatTextView.contentSize.height
            self.heightChatView.constant = max(35.0, height)
            if height > 35 {
                self.heightChatView.constant = min(100.0, height)
            }
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.sendButton.isEnabled = (self.chatTextView.text ?? "").trimSpace() != ""
        }).disposed(by: disposeBag)
        
        setupTableView()
        setupEmojiView()
    }
    
    func setupTableView() {
        // setup tableview
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = true
        tableView.estimatedRowHeight = 100
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.cr.footer?.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        tableView.register(UINib.init(nibName: LeftTextMessageCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: LeftTextMessageCell.cellIdentifier)
        tableView.register(UINib.init(nibName: RightTextMessageCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: RightTextMessageCell.cellIdentifier)
        tableView.register(UINib.init(nibName: CenterMessageCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: CenterMessageCell.cellIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SpaceCell")
        /*
        // load more
        tableView.cr.addFootRefresh(animator: CRFooterLoading()) { [weak self] in
            guard let `self` = self else { return }
            //self.viewModel.getContentChat()
        }
        */
        viewModel.hasLoadMore.asObservable()
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (hasLoadMore) in
                self?.tableView.cr.endLoadingMore()
                if hasLoadMore {
                    /// Reset no more data
                    self?.tableView.cr.resetNoMore()
                } else {
                    /// If no more data
                    self?.tableView.cr.noticeNoMoreData()
                    self?.tableView.cr.removeFooter()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupEmojiView() {
        let keyboardSettings = KeyboardSettings(bottomType: .categories)
        emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        
        emojiContainerView.backgroundColor = UIColor.white
        emojiContainerView.addSubview(self.emojiView)
        self.emojiView.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalToSuperview()
        })
    }
    
    private func bindData() {
        viewModel.techName.asDriver().drive(self.navigationBar.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.refreshTableView.asObserver()
            .subscribe(onNext: { [weak self] in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper

extension ChatVC {
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private func addObserverNotification() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .asObservable()
            .subscribe(onNext: { [weak self] (notification) in
                self?.keyboardWillShow(notification: notification)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .asObservable()
            .subscribe(onNext: { [weak self] (notification) in
                self?.keyboardWillHide(notification: notification)
            })
            .disposed(by: disposeBag)
    }
    
    private func tapActions() {
        emojiButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.selectedEmoji = !self.selectedEmoji

                    self.chatTextView.resignFirstResponder()
                    self.chatTextView.inputView = self.selectedEmoji ? self.emojiContainerView : nil
                    self.chatTextView.becomeFirstResponder()
                    self.emojiButton.setImage(UIImage(named: self.selectedEmoji ? "keyboard" : "emoji"), for: .normal)
                    
                    UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                        self.view.layoutIfNeeded()
                    }, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    
        sendButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.sendMessage()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - chat methods

extension ChatVC {
    
    private func sendMessage() {
        let textMessage = self.chatTextView.text ?? ""
        self.chatTextView.text = nil
        self.sendButton.isEnabled = false
        
        // insert message first
        let messageModel = PMessageModel()
        messageModel.content = textMessage
        messageModel.type = "1"
        messageModel.contentType = "0"
        messageModel.time = Date().convertTo(region: PDefined.serverRegion).toFormat("yyyy-MM-dd HH:mm:ss")
        let cellVMs = self.insertLatestMessages([messageModel])
        
        viewModel.sendMessage(text: textMessage) { [weak self] (code, data) in
            guard let `self` = self else { return }
            if code == 1, let message = data as? PMessageModel {
                //self.insertLatestMessages([message])
                if let cellVM = cellVMs.first {
                    cellVM.message.id = message.id
                }
                NotificationCenter.default.post(name: NSNotification.Name(kRefreshConversationNotification), object: nil)
            } else if let errorMessage = data as? String {
                AppMessagesManager.shared.showMessage(messageType: .error, message: errorMessage)
            }
        }
    }
    
    private func insertLatestMessages(_ messages: [PMessageModel]) -> [MessageCellVM] {
        var cellVMs = [MessageCellVM]()
        for message in messages {
            let messageCellVM = MessageCellVM(message: message, contentMessage: self.viewModel.contentChat)
            self.viewModel.messageList.insert(messageCellVM, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
            cellVMs.append(messageCellVM)
        }
        self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.heightChatView.constant = 35
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
        
        return cellVMs
    }
}

// MARK: - Keyboard Observer

extension ChatVC {
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardRect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            //let height = keyboardRect.cgRectValue.height
            let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
            let convertedFrame = self.view.convert(keyboardRect.cgRectValue, from: nil)
            let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
            self.bottomConstraint.constant = heightOffset
            self.emojiContainerView.height = convertedFrame.height
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        if let keyboardRect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue, let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
            //let height = keyboardRect.cgRectValue.height
            let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt
            let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
            let convertedFrame = self.view.convert(keyboardRect.cgRectValue, from: nil)
            let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
            self.bottomConstraint.constant = -heightOffset
            
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
}

// MARK: - EmojiViewDelegate

extension ChatVC: EmojiViewDelegate {
    
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        chatTextView.insertText(emoji)
    }
    
    // callback when tap change keyboard button on keyboard
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        chatTextView.inputView = nil
        chatTextView.keyboardType = .default
        chatTextView.reloadInputViews()
    }
    
    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        chatTextView.deleteBackward()
    }
    
    // callback when tap dismiss button on keyboard
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        chatTextView.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension ChatVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel == nil {
            return 0
        }
        return viewModel.messageList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > viewModel.messageList.value.count - 1 {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.messageList.value[indexPath.row]
        if cellViewModel.message.typeInt == 1 { // user
            return self.rightMessageCell(indexPath: indexPath, message: cellViewModel)
        } else { // tech
            return self.leftMessageCell(indexPath: indexPath, message: cellViewModel)
        }
    }
}

// MARK: - UITableViewDataSource

extension ChatVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.view.endEditing(true)
        let cellViewModel = viewModel.messageList.value[indexPath.row]
    }
}

// MARK: - UITableViewCell

extension ChatVC {
    
    private func leftMessageCell(indexPath: IndexPath, message: MessageCellVM) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftTextMessageCell.cellIdentifier, for: indexPath) as! LeftTextMessageCell
        cell.viewModel = message
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.avatarClickBlock = { [weak self] in
            // TODO: Write code here
        }
        
        return cell
    }
    
    private func rightMessageCell(indexPath: IndexPath, message: MessageCellVM) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RightTextMessageCell.cellIdentifier, for: indexPath) as! RightTextMessageCell
        cell.viewModel = message
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func centerMessageCell(indexPath: IndexPath, message: MessageCellVM) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CenterMessageCell.cellIdentifier, for: indexPath) as! CenterMessageCell
        cell.viewModel = message
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        if message.message.content.count == 0 {
            let spaceCell = tableView.dequeueReusableCell(withIdentifier: "SpaceCell", for: indexPath)
            spaceCell.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1.0)
            spaceCell.backgroundColor = UIColor.clear
            spaceCell.snp.makeConstraints { (make) in
                make.height.equalTo(1)
            }
            return spaceCell
        }
        return cell
    }
}

// MARK: - Navigation

extension ChatVC {
    
}











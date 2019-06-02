//
//  ConversationVC.swift
//  LianChat
//
//  Created by Mac on 1/15/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import SwipeCellKit
import UIKit

class ConversationVC: UIViewController {

    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    private let disposeBag = DisposeBag()
    private var viewModel: ConversationVM!
    var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initComponent()
        bindData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: - Initialization

extension ConversationVC {
    
    private func initComponent() {
        viewModel = ConversationVM()
        navigationBar.setupView(title: "Chat".localized())
        navigationBar.divView.isHidden = false
        
        // setup tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(UINib.init(nibName: PrivateConversationCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: PrivateConversationCell.cellIdentifier)
        tableView.backgroundColor = UIColor.clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // refresh collection view
        tableView.cr.addHeadRefresh(animator: CRHeaderRefresh()) { [weak self] in
            self?.viewModel?.listConversation()
        }
        
        // indicator view
        viewModel.shouldShowIndicatorView.asDriver()
            .drive(onNext: { [weak self] (isShow) in
                self?.tableView.showIndicatorView(isShow: isShow)
                self?.tableView.cr.endHeaderRefresh()
            })
            .disposed(by: disposeBag)
        
        addObserverNotification()
    }
    
    private func bindData() {
        viewModel.noDataStr.asDriver()
            .drive(onNext: { [weak self] (message) in
                self?.tableView.showNoResultView(isShow: message.count > 0, title: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.conversationList.asDriver()
            .drive(onNext: { [weak self] (list) in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper

extension ConversationVC {
    
    private func addObserverNotification() {
        NotificationCenter.default.rx.notification(NSNotification.Name(kRefreshConversationNotification))
            .asObservable()
            .subscribe(onNext: { [weak self] (notification) in
                self?.viewModel?.listConversation()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDataSource

extension ConversationVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.conversationList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrivateConversationCell.cellIdentifier, for: indexPath) as! PrivateConversationCell
        cell.delegate = self
        let cellVM = self.viewModel.conversationList.value[indexPath.row]
        cell.viewModel = cellVM
        cell.selectionStyle = .none
        cell.avatarClickBlock = { [weak self] in
            // write
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ConversationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let conversationCellVM = viewModel.conversationList.value[indexPath.row]
        self.goToChatVC(conversation: conversationCellVM.conversation)
    }
}

extension ConversationVC: SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let conversation = self.viewModel.conversationList.value[indexPath.row].conversation
        let deleteAction = SwipeAction(style: .default, title: nil) { [weak self] action, indexPath in
            guard let `self` = self else { return }
            // handle action by updating model with deletion
            self.deleteConversation(atIndex: indexPath)
        }
        deleteAction.hidesWhenSelected = true
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = UIColor(hexString: "00C464")
        
        return [deleteAction]
    }
    
    func deleteConversation(atIndex index: IndexPath) {
        let conversation = self.viewModel.conversationList.value[index.row].conversation
        let message = "Bạn có chắc muốn xoá cuộc hội thoại này không?".localized()
        _ = EZAlertController.alert("", message: message, buttons: ["OK", "Huỷ"], tapBlock: { (action, index) in
            if index == 0 {
                // write code here
            }
        })
    }
}

// MARK: - Helper

extension ConversationVC {
    
    private func refreshView() {
        tableView.cr.beginHeaderRefresh()
    }
}

// MARK: - Navigation

extension ConversationVC {
    
    func goToChatVC(conversation: PConversationModel) {
        let chatVC = ChatVC(conversation.user?.id ?? 0, conversation.tech?.id ?? 0)
        chatVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}










//
//  FeedbackListVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class FeedbackListVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: FeedbackListVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
}

// MARK: - Initialization

extension FeedbackListVC {
    
    private func initComponent() {
        viewModel = FeedbackListVM()
        navigationBar.customBackAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // setup tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib.init(nibName: FeedbackCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: FeedbackCell.cellIdentifier)
        
        // indicator view
        viewModel.shouldShowIndicatorView.asDriver()
            .drive(onNext: { [weak self] (isShow) in
                self?.tableView.showIndicatorView(isShow: isShow)
                self?.tableView.cr.endHeaderRefresh()
                UIView.animate(withDuration: 0.3, animations: {
                    self?.tableView.alpha = 1.0
                })
            })
            .disposed(by: disposeBag)
        
        // refresh table view
        tableView.cr.addHeadRefresh(animator: CRHeaderRefresh()) { [weak self] in
            self?.viewModel.getFeedbackList()
        }
    }
    
    private func initData() {
        viewModel.noDataStr.asDriver()
            .drive(onNext: { [weak self] (message) in
                self?.tableView.showNoResultView(isShow: message.count > 0, title: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.hasNoRead.asDriver()
            .drive(onNext: { [weak self] (hasNoRead) in
                self?.notificationButton.setImage(hasNoRead ? #imageLiteral(resourceName: "notification-bell-active") : #imageLiteral(resourceName: "notification-bell"), for: .normal)
            })
            .disposed(by: disposeBag)
        
        viewModel.feedbackList.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: FeedbackCell.cellIdentifier, cellType: FeedbackCell.self)) { index, cellViewModel, cell in
                cell.viewModel = cellViewModel
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] (indexPath) in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                let feedbackCellVM = self.viewModel.feedbackList.value[indexPath.row]
                if let feedbackModel = feedbackCellVM.model, feedbackModel.response.count > 0 {
                    self.showFeedbackDetail(feedbackModel)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension FeedbackListVC {
    
    func showFeedbackDetail(_ feedbackModel: PFeedbackModel) {
        let feedbackDetailVC = FeedbackDetailVC(feedbackModel)
        feedbackDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(feedbackDetailVC, animated: true)
    }
}






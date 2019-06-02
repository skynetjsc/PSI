//
//  MoreNotificationVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/30/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class MoreNotificationVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: MoreNotificationVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
}

// MARK: - Initialization

extension MoreNotificationVC {
    
    private func initComponent() {
        viewModel = MoreNotificationVM()
        
        // setup tableview
        //tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib.init(nibName: MoreNotificationCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: MoreNotificationCell.cellIdentifier)
    }
    
    private func initData() {
        viewModel.notificationList.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: MoreNotificationCell.cellIdentifier, cellType: MoreNotificationCell.self)) { index, cellViewModel, cell in
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
                for item in self.viewModel.notificationList.value {
                    item.isSelected.accept(false)
                }
                let cellVM = self.viewModel.notificationList.value[indexPath.row]
                cellVM.isSelected.accept(true)
            })
            .disposed(by: disposeBag)
    }
}

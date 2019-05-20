//
//  PaymentVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PaymentVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: PaymentVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
    
}

// MARK: - Initialization

extension PaymentVC {
    
    private func initComponent() {
        viewModel = PaymentVM()
        
        // setup tableview
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib.init(nibName: PaymentMethodCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: PaymentMethodCell.cellIdentifier)
        tableView.register(UINib.init(nibName: PaymentFooterView.cellIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: PaymentFooterView.cellIdentifier)
        
        // indicator view
        viewModel.shouldShowIndicatorView.asDriver()
            .drive(onNext: { [weak self] (isShow) in
                self?.tableView.showIndicatorView(isShow: isShow)
            })
            .disposed(by: disposeBag)
    }
    
    private func initData() {
        viewModel.noDataStr.asDriver()
            .drive(onNext: { [weak self] (message) in
                self?.tableView.showNoResultView(isShow: message.count > 0, title: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.serviceList.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: PaymentMethodCell.cellIdentifier, cellType: PaymentMethodCell.self)) { index, cellViewModel, cell in
//                cell.viewModel = cellViewModel
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = .none
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .asDriver()
            .drive(onNext: { [weak self] (indexPath) in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
                
            })
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Navigation

extension PaymentVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 124.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: PaymentFooterView.cellIdentifier) as? PaymentFooterView
        footerView?.addCardHandler = { [weak self] in
            guard let self = self else { return }
            AppMessagesManager.shared.showBookingConfirm(confirmCompletion: {
                // write code here
            })
        }
        
        return footerView
    }
}

// MARK: - Navigation

extension PaymentVC {
    
    
}






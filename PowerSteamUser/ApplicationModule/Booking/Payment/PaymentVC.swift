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
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: PaymentVM!
    
    init(params: [String: Any]) {
        viewModel = PaymentVM(params)
        super.init(nibName: "PaymentVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
                //self?.tableView.showIndicatorView(isShow: isShow)
            })
            .disposed(by: disposeBag)
    }
    
    private func initData() {
        viewModel.enableConfirm.asDriver().drive(self.confirmButton.rx.isEnabled).disposed(by: disposeBag)
        
        viewModel.noDataStr.asDriver()
            .drive(onNext: { [weak self] (message) in
                //self?.tableView.showNoResultView(isShow: message.count > 0, title: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.paymentList.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: PaymentMethodCell.cellIdentifier, cellType: PaymentMethodCell.self)) { index, cellViewModel, cell in
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
                
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.viewModel.booking(completion: { [weak self] (code, message) in
                    guard let self = self else { return }
                    if code > 0 {
                        AppMessagesManager.shared.showBookingConfirm(confirmCompletion: {
                            self.showSearchingTech(Int(message) ?? 0)
                        })
                    } else {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                    }
                })
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
    
    func showSearchingTech(_ bookingID: Int) {
        if let navi = self.navigationController {
            let searchingTechVC = SearchingTechVC(bookingID)
            navi.pushViewController(searchingTechVC, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                var viewControllers = [UIViewController]()
                for viewController in navi.viewControllers {
                    if viewController.isKind(of: ServiceListVC.self) || viewController.isKind(of: SearchingTechVC.self) {
                        viewControllers.append(viewController)
                    }
                }
                navi.viewControllers = viewControllers
            }
        }
    }
}






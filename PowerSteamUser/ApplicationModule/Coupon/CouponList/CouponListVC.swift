//
//  CouponListVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CouponListVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: CouponListVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
}

// MARK: - Initialization

extension CouponListVC {
    
    private func initComponent() {
        viewModel = CouponListVM()
        navigationBar.customBackAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // setup tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib.init(nibName: CouponCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: CouponCell.cellIdentifier)
        
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
            self?.viewModel.getPromotionList()
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
        
        viewModel.couponList.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: CouponCell.cellIdentifier, cellType: CouponCell.self)) { index, cellViewModel, cell in
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
                let couponCellVM = self.viewModel.couponList.value[indexPath.row]
                if let promotionModel = couponCellVM.model {
                    couponCellVM.isRead.accept(true)
                    self.showCouponDetail(promotionModel)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension CouponListVC {
    
    func showCouponDetail(_ promotionModel: PPromotionModel) {
        let couponDetailVC = CouponDetailVC(promotionModel)
        couponDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(couponDetailVC, animated: true)
    }
}






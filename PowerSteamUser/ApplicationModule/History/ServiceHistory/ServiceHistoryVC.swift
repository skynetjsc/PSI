//
//  ServiceHistoryVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/21/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ServiceHistoryVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: ServiceHistoryVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
    
    @IBAction func segmentedDidChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewModel.typeHistory = 3
        case 1:
            viewModel.typeHistory = 1
        default:
            viewModel.typeHistory = 2
        }
        self.tableView.alpha = 0.0
        tableView.cr.beginHeaderRefresh()
    }
}

// MARK: - Initialization

extension ServiceHistoryVC {
    
    private func initComponent() {
        viewModel = ServiceHistoryVM()
        navigationBar.customBackAction = { [weak self] in
            guard let self = self else { return }
            if let navi = self.navigationController, navi.viewControllers.count > 1 {
                navi.popViewController(animated: true)
            } else {
                self.tabBarController?.selectedIndex = 0
            }
        }
        
        // setup tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib.init(nibName: ServiceHistoryCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: ServiceHistoryCell.cellIdentifier)
        
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
            self?.viewModel.getServiceHistory()
        }
        
        notificationButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                self?.showCouponList()
            })
            .disposed(by: disposeBag)
    }
    
    private func initData() {
        viewModel.noDataStr.asDriver()
            .drive(onNext: { [weak self] (message) in
                self?.tableView.showNoResultView(isShow: message.count > 0, title: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.bookList.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: ServiceHistoryCell.cellIdentifier, cellType: ServiceHistoryCell.self)) { index, cellViewModel, cell in
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
                if let bookModel = self.viewModel.bookList.value[indexPath.row].model {
                    switch bookModel.bookActiveType {
                    case .completed:
                        if bookModel.rating > 0 {
                            self.showBookDetail(bookModel)
                        } else {
                            self.showSearchingTech(bookModel)
                        }
                    case .notAssign, .assigned, .doing:
                        self.showSearchingTech(bookModel)
                    case .userCanceled, .techCanceled, .systemCanceled:
                        self.showBookDetail(bookModel)
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Navigation

extension ServiceHistoryVC {
    
    func showSearchingTech(_ bookModel: PBookModel) {
        let searchingTechVC = SearchingTechVC(bookModel)
        searchingTechVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchingTechVC, animated: true)
    }
    
    func showBookDetail(_ bookModel: PBookModel) {
        let bookDetailVC = BookDetailVC(bookModel.bookingID)
        bookDetailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(bookDetailVC, animated: true)
    }
    
    func showCouponList() {
        let couponListVC = CouponListVC()
        couponListVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(couponListVC, animated: true)
    }
}





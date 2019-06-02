//
//  PeriodServiceVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/25/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PeriodServiceVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: PeriodServiceVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
    
    @IBAction func segmentedDidChange(_ sender: Any) {
        viewModel.typeHistory = segmentedControl.selectedSegmentIndex + 1
        tableView.alpha = 0.0
        tableView.cr.beginHeaderRefresh()
    }
}

// MARK: - Initialization

extension PeriodServiceVC {
    
    private func initComponent() {
        viewModel = PeriodServiceVM()
        navigationBar.customBackAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // setup tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib.init(nibName: PeriodServiceCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: PeriodServiceCell.cellIdentifier)
        
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
            self?.viewModel.getSchedule()
        }
    }
    
    private func initData() {
        viewModel.noDataStr.asDriver()
            .drive(onNext: { [weak self] (message) in
                self?.tableView.showNoResultView(isShow: message.count > 0, title: message)
            })
            .disposed(by: disposeBag)
        
        viewModel.bookList.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: PeriodServiceCell.cellIdentifier, cellType: PeriodServiceCell.self)) { index, cellViewModel, cell in
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

extension PeriodServiceVC {
    
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
}









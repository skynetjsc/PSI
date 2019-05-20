//
//  ServiceListVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import CoreLocation
import RxCocoa
import RxSwift
import UIKit

class ServiceListVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: ServiceListVM!
    
    init(_ address: String, _ location: CLLocation) {
        viewModel = ServiceListVM(address, location)
        super.init(nibName: "ServiceListVC", bundle: nil)
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

extension ServiceListVC {
    
    private func initComponent() {
        // setup tableview
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib.init(nibName: ServiceListCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: ServiceListCell.cellIdentifier)
        
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
            .bind(to: tableView.rx.items(cellIdentifier: ServiceListCell.cellIdentifier, cellType: ServiceListCell.self)) { index, cellViewModel, cell in
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
                self.showServicePakage(self.viewModel.serviceList.value[indexPath.row].model)
            })
            .disposed(by: disposeBag)
        
    }
}

// MARK: - Navigation

extension ServiceListVC {
    
    func showServicePakage(_ service: PServiceModel) {
        let servicePakageVC = ServicePackageVC(viewModel.address, viewModel.location, service)
        navigationController?.pushViewController(servicePakageVC, animated: true)
    }
}









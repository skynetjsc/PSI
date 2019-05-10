//
//  HomeVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class HomeVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var bookingView: UIView!
    @IBOutlet weak var bookingButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: HomeVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

}

// MARK: - Initialization

extension HomeVC {
    
    private func initComponent() {
        viewModel = HomeVM()
        setupNavigationBar()
        tapActions()
    }
    
    private func setupNavigationBar() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.snp.makeConstraints { (make) in
            make.width.equalTo(44)
        }
        
        let notificationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        notificationButton.setImage(#imageLiteral(resourceName: "notification-bell"), for: .normal)
        notificationButton.snp.makeConstraints { (make) in
            make.width.equalTo(44)
        }
        
        navigationBar.setupView(title: "", imageIcon: #imageLiteral(resourceName: "logo-navi"), leftButtons: [menuButton], rightButtons: [notificationButton])
        navigationBar.divView.isHidden = false
        
        menuButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
        
        notificationButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func initData() {
        
    }
    
    private func tapActions() {
        bookingButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension HomeVC {
    
}





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
    fileprivate var sideManager: SideMenuManager!
    var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //AppMessagesManager.shared.showChooseCarView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false
            
            configSideMenu()
            
            AppMessagesManager.shared.showBookOnWayView()
        }
    }
    
}

// MARK: - Initialization

extension HomeVC {
    
    private func initComponent() {
        viewModel = HomeVM()
        setupNavigationBar()
        configSideMenu()
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
                guard let `self` = self else { return }
                // Show left menu
                guard let leftVC = self.sideManager.menuLeftNavigationController else { return }
                self.present(leftVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        notificationButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
    }
    
    func configSideMenu() {
        if sideManager == nil {
            sideManager = SideMenuManager.default
        }
        let menuController = LeftMenuVC()
        let leftNavigationController = UISideMenuNavigationController(rootViewController: menuController)
        sideManager.menuLeftNavigationController = leftNavigationController
        sideManager.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        
        sideManager.menuFadeStatusBar = false
        sideManager.menuPresentMode = .menuSlideIn
        sideManager.menuWidth = round(self.view.width * 0.6)
        sideManager.menuShadowColor = UIColor.black
        sideManager.menuShadowOpacity = 0.5
    }
    
    private func initData() {
        
    }
    
    private func tapActions() {
        bookingButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showServiceList()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension HomeVC {
    
    func showServiceList() {
        let serviceList = ServiceListVC()
        navigationController?.pushViewController(serviceList, animated: true)
    }
}





//
//  LeftMenuVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class LeftMenuVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var serviceButton: UIButton!
    @IBOutlet weak var walletButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var scheduleMeetButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
}

// MARK: - Initialization

extension LeftMenuVC {
    
    private func initComponent() {
        navigationController?.isNavigationBarHidden = true
        tapAction()
    }
    
    private func initData() {
        if let userModel = PAppManager.shared.currentUser {
            nameLabel.text = userModel.name
        }
    }
    
    private func tapAction() {
        nameButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showProfile()
            })
            .disposed(by: disposeBag)
        
        serviceButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showMainHome()
            })
            .disposed(by: disposeBag)
        
        walletButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showMainHome()
            })
            .disposed(by: disposeBag)
        
        profileButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showProfile()
            })
            .disposed(by: disposeBag)
        
        scheduleButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showMainHome()
            })
            .disposed(by: disposeBag)
        
        historyButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showMainHome()
            })
            .disposed(by: disposeBag)
        
        scheduleMeetButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showMainHome()
            })
            .disposed(by: disposeBag)
        
        notificationButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showMainHome()
            })
            .disposed(by: disposeBag)
        
        reportButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showMainHome()
            })
            .disposed(by: disposeBag)
        
        supportButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showMainHome()
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                _ = EZAlertController.alert("", message: "Bạn có chắc muốn đăng xuất không?", buttons: ["OK", "Huỷ"], tapBlock: { (action, index) in
                    if index == 0 {
                        PAppManager.shared.accessToken = nil
                        PAppManager.shared.currentUser = nil
                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                            appDelegate.showLogin()
                        }
                    }
                })
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension LeftMenuVC {
    
    func showMainHome() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showProfile() {
        let profileVC = ProfileVC()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}







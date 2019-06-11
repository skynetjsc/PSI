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
                // Hide left menu prevent crash for next show
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
                _ = EZAlertController.alert(PAboutApp.appName, message: "Tính năng đang trong quá trình phát triển, vui lòng trở lại sau!".localized())
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
                self?.showPeriodService()
            })
            .disposed(by: disposeBag)
        
        historyButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showServiceHistory()
            })
            .disposed(by: disposeBag)
        
        scheduleMeetButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showPeriodService()
            })
            .disposed(by: disposeBag)
        
        notificationButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showCouponList()
            })
            .disposed(by: disposeBag)
        
        reportButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showFeedbackList()
            })
            .disposed(by: disposeBag)
        
        supportButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                //self?.showConversation()
                if let url = URL(string: "tel://\(19001000)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    _ = EZAlertController.alert(PAboutApp.appName, message: "Không hỗ trợ việc gọi điện trên thiết bị này")
                }
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                _ = EZAlertController.alert("", message: "Bạn có chắc muốn đăng xuất không?", buttons: ["OK", "Huỷ"], tapBlock: { (action, index) in
                    if index == 0 {
                        PAppManager.shared.accessToken = nil
                        PAppManager.shared.currentUser = nil
                        // Hide left menu prevent crash for next show
                        self.dismiss(animated: false, completion: {
                            // Show login screen
                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                                appDelegate.showLogin()
                            }
                        })
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
    
    func showServiceHistory() {
        let serviceHistoryVC = ServiceHistoryVC()
        navigationController?.pushViewController(serviceHistoryVC, animated: true)
    }
    
    func showPeriodService() {
        let periodServiceVC = PeriodServiceVC()
        navigationController?.pushViewController(periodServiceVC, animated: true)
    }
    
    func showCouponList() {
        let couponListVC = CouponListVC()
        navigationController?.pushViewController(couponListVC, animated: true)
    }
    
    func showFeedbackList() {
        let feedbackList = FeedbackListVC()
        navigationController?.pushViewController(feedbackList, animated: true)
    }
    
    func showConversation() {
        let conversationVC = ConversationVC()
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}







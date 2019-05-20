//
//  ProfileVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/15/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxSwift
import UIKit

class ProfileVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var navigationBar: NavigationView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var notiLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - Outlet
    let disposeBag = DisposeBag()
    var viewModel: ProfileVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
}

// MARK: - Initialization

extension ProfileVC {
    
    private func initComponent() {
        viewModel = ProfileVM()
        tapAction()
    }
    
    private func tapAction() {
        logoutButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                //guard let self = self else { return }
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
    
    private func initData() {
        viewModel.nameStr.asDriver().drive(self.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.birthdayStr.asDriver().drive(self.birthdayLabel.rx.text).disposed(by: disposeBag)
        viewModel.phoneStr.asDriver().drive(self.phoneLabel.rx.text).disposed(by: disposeBag)
        viewModel.addressStr.asDriver().drive(self.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.paymentStr.asDriver().drive(self.paymentLabel.rx.text).disposed(by: disposeBag)
        viewModel.notificationStr.asDriver().drive(self.notiLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.avatarLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.avatarImage.kf.setImage(with: url, placeholder: PDefined.noAvatar, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension ProfileVC {
    
    
}






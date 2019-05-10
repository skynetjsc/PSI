//
//  ForgotPasswordVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ForgotPasswordVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: ForgotPasswordVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

}

// MARK: - Initialization

extension ForgotPasswordVC {
    
    private func initComponent() {
        viewModel = ForgotPasswordVM()
        
        phoneField.rx.text.orEmpty.asDriver().drive(self.viewModel.phoneStr).disposed(by: disposeBag)
        viewModel.enableConfirm.asDriver().drive(self.confirmButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func initData() {
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                if self.viewModel.phoneStr.value.isValidEmail() || self.viewModel.phoneStr.value.isValidPhoneNumber() {
                    self.showOTP()
                } else {
                    AppMessagesManager.shared.showMessage(messageType: .error, message: "Số điện thoại hoặc email không hợp lệ.".localized())
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension ForgotPasswordVC {
    
    func showOTP() {
        let signupOTPVC = SignupOtpVC()
        navigationController?.pushViewController(signupOTPVC, animated: true)
    }
}







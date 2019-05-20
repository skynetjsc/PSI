//
//  RegisterVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class RegisterVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: RegisterVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

}

// MARK: - Initialization

extension RegisterVC {
    
    private func initComponent() {
        viewModel = RegisterVM()
        
        nameField.rx.text.orEmpty.asDriver().drive(self.viewModel.nameStr).disposed(by: disposeBag)
        phoneField.rx.text.orEmpty.asDriver().drive(self.viewModel.phoneStr).disposed(by: disposeBag)
        emailField.rx.text.orEmpty.asDriver().drive(self.viewModel.emailStr).disposed(by: disposeBag)
        viewModel.enableRegister.asDriver().drive(self.registerButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func initData() {
        registerButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                if !self.viewModel.phoneStr.value.isValidPhoneNumber() {
                    AppMessagesManager.shared.showMessage(messageType: .error, message: "Số điện thoại không hợp lệ".localized(), completion: {
                        self.phoneField.becomeFirstResponder()
                    })
                    return
                }
                if !self.viewModel.emailStr.value.isValidEmail() {
                    AppMessagesManager.shared.showMessage(messageType: .error, message: "Email không hợp lệ".localized(), completion: {
                        self.emailField.becomeFirstResponder()
                    })
                    return
                }
                
                self.viewModel.verifyCode(completion: { (code, message) in
                    if code > 0 {
                        self.showSignupOtpVC()
                    } else {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showLogin()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension RegisterVC {
    
    func showLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func showSignupOtpVC() {
        let signupOtpVC = SignupOtpVC(viewModel.otpCode, viewModel.phoneStr.value, viewModel.getInputParams())
        navigationController?.pushViewController(signupOtpVC, animated: true)
    }
}





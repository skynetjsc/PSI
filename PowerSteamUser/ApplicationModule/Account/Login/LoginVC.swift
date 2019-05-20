//
//  LoginVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxSwift
import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: LoginVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
}

// MARK: - Initialization

extension LoginVC {
    
    private func initComponent() {
        viewModel = LoginVM()
        
        accountField.rx.text.orEmpty.asDriver().drive(self.viewModel.accountStr).disposed(by: disposeBag)
        passwordField.rx.text.orEmpty.asDriver().drive(self.viewModel.passwordStr).disposed(by: disposeBag)
        viewModel.enableLogin.asDriver().drive(self.loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func initData() {
        loginButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.viewModel.login(completion: { (code, message) in
                    if code > 0 {
                        self?.showMainHome()
                    } else {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        registerButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showRegister()
            })
            .disposed(by: disposeBag)
        
        forgotButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                self?.showForgotPassword()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension LoginVC {
    
    func showMainHome() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showMainHome()
        }
    }
    
    func showRegister() {
        let registerVC = RegisterVC()
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    func showForgotPassword() {
        let forgotVC = ForgotPasswordVC()
        navigationController?.pushViewController(forgotVC, animated: true)
    }
}








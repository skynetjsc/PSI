//
//  SignupOtpVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import SVPinView
import UIKit

class SignupOtpVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet var pinView: SVPinView!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: SignupOtpVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

}

// MARK: - Initialization

extension SignupOtpVC {
    
    private func initComponent() {
        viewModel = SignupOtpVM()
        configurePinView()
        viewModel.enableConfirm.asDriver().drive(self.confirmButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    func configurePinView() {
        pinView.pinLength = 4
        pinView.secureCharacter = ""
        pinView.interSpace = 16
        pinView.textColor = PDefined.normalTextColor
        pinView.borderLineColor = UIColor.white
        pinView.activeBorderLineColor = UIColor.white
        pinView.borderLineThickness = 1
        pinView.shouldSecureText = false
        pinView.allowsWhitespaces = false
        pinView.style = .none
        pinView.fieldBackgroundColor = UIColor(hexString: "F4F4F4")
        pinView.activeFieldBackgroundColor = UIColor(hexString: "F2F2F2")
        pinView.fieldCornerRadius = 4
        pinView.activeFieldCornerRadius = 4
        pinView.placeholder = "*"
        pinView.becomeFirstResponderAtIndex = 0
        
        pinView.font = UIFont.systemFont(ofSize: 15)
        pinView.keyboardType = .numberPad
        pinView.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        pinView.didFinishCallback = didFinishEnteringPin(pin:)
        pinView.didChangeCallback = { [weak self] pin in
            //print("The entered pin is \(pin)")
            self?.viewModel.enableConfirm.accept(pin.count >= 4)
        }
    }
    
    private func initData() {
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let pin = self.pinView.getPin()
                guard !pin.isEmpty else {
                    //showAlert(title: "Error", message: "Pin entry incomplete")
                    return
                }
                
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper

extension SignupOtpVC {
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    func didFinishEnteringPin(pin: String) {
        //print(pin)
        viewModel.enableConfirm.accept(true)
    }
}

// MARK: - Navigation

extension SignupOtpVC {
    
    
}




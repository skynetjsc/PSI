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
    @IBOutlet weak var countTime: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var countDisposeBag: DisposeBag!
    var viewModel: SignupOtpVM!
    var count: Int = 30
    
    init(_ otpCode: Int, _ phoneNumber: String, _ params: [String: Any]) {
        viewModel = SignupOtpVM(otpCode, phoneNumber, params)
        super.init(nibName: "SignupOtpVC", bundle: nil)
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

extension SignupOtpVC {
    
    private func initComponent() {
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
        pinView.placeholder = ""
        //pinView.becomeFirstResponderAtIndex = 0
        
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
        // setup attributedText for summaryLabel
        let summary = "Vui lòng nhập mã xác thực gồm 04 chữ số vừa gửi vào số điện thoại \(viewModel.phoneNumber) của bạn"
        summaryLabel.text = summary
        let textRange = NSMakeRange(0, summary.count)
        let attributedText = NSMutableAttributedString(string: summary)
        attributedText.addAttributes([NSAttributedString.Key.font: self.summaryLabel.font,
                                      NSAttributedString.Key.foregroundColor: self.summaryLabel.textColor], range: textRange)
        if let range = summary.range(of: "04 chữ số") {
            let nsRange = summary.nsRange(from: range)
            attributedText.addAttributes([NSAttributedString.Key.font: PDefined.fontBold(size: 14),
                                          NSAttributedString.Key.foregroundColor: self.summaryLabel.textColor], range: nsRange)
        }
        if let range = summary.range(of: "\(viewModel.phoneNumber)") {
            let nsRange = summary.nsRange(from: range)
            attributedText.addAttributes([NSAttributedString.Key.font: PDefined.fontBold(size: 14),
                                          NSAttributedString.Key.foregroundColor: self.summaryLabel.textColor], range: nsRange)
        }
        summaryLabel.attributedText = attributedText
        // end
        resendButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.pinView.clearPin()
                self.viewModel.verifyCode(completion: { (code, message) in
                    if code > 0 {
                        self.setupCountTime()
                    } else {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                let pinCode = self.pinView.getPin()
                guard !pinCode.isEmpty else {
                    //showAlert(title: "Error", message: "Pin entry incomplete")
                    return
                }
                if pinCode != self.viewModel.otpCode.description {
                    AppMessagesManager.shared.showMessage(messageType: .error, message: "Mã xác thực không chính xác".localized())
                    return
                }
                self.viewModel.register(pinCode: pinCode, completion: { (code, message) in
                    if code > 0 {
                        self.showMainHome()
                    } else {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                    }
                })
            })
            .disposed(by: disposeBag)
        
        setupCountTime()
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
    
    func setupCountTime() {
        countDisposeBag = DisposeBag()
        count = 30
        resendButton.isEnabled = false
        countTime.isHidden = false
        countTime.text = "sau \(self.count)s"
        Observable<Int>.interval(1.0, scheduler: MainScheduler.instance)
            //.debug("interval")
            .subscribe(onNext: { [weak self] (counter) in
                guard let self = self else { return }
                self.countTime.text = "sau \(self.count)s"
                if self.count <= 0 {
                    self.countDisposeBag = nil
                    self.resendButton.isEnabled = true
                    self.countTime.isHidden = true
                    return
                }
                self.count -= 1
            })
            .disposed(by: countDisposeBag)
    }
}

// MARK: - Navigation

extension SignupOtpVC {
    
    func showMainHome() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.showMainHome()
        }
    }
}




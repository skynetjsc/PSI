//
//  AddCouponVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class AddCouponVC: UIViewController {
    
    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var couponField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: AddCouponVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
    
}

// MARK: - Initialization

extension AddCouponVC {
    
    private func initComponent() {
        viewModel = AddCouponVM()
        
        couponField.rx.text.orEmpty.asDriver().drive(self.viewModel.couponStr).disposed(by: disposeBag)
        viewModel.enableConfirm.asDriver().drive(self.confirmButton.rx.isEnabled).disposed(by: disposeBag)
    }
    
    private func initData() {
        couponField.rx.controlEvent([.editingDidBegin])
            .asObservable()
            .subscribe(onNext: { _ in
                //print("editing state changed")
                if let code = UIPasteboard.general.string {
                    self.couponField.insertText(code)
                }
            })
            .disposed(by: disposeBag)

        
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension AddCouponVC {
    
    
}

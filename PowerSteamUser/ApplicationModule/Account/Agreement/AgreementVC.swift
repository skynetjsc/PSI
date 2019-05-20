//
//  AgreementVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import ActiveLabel
import RxCocoa
import RxSwift
import SVPinView
import UIKit

class AgreementVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var summaryLabel: ActiveLabel!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: AgreementVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

}

// MARK: - Initialization

extension AgreementVC {
    
    private func initComponent() {
        viewModel = AgreementVM()
        //navigationBar.hideLeftButton()
        viewModel.enableConfirm.asDriver().drive(self.confirmButton.rx.isEnabled).disposed(by: disposeBag)
        
        // add custom type
        let customType1 = ActiveType.custom(pattern: "\\schính sách\\b") //Regex that looks for "chính sách"
        let customType2 = ActiveType.custom(pattern: "\\sđiều khoản\\b") //Regex that looks for "điều khoản"
        summaryLabel.enabledTypes.append(contentsOf: [customType1, customType2])
        summaryLabel.customColor[customType1] = PDefined.mainColor
        summaryLabel.customColor[customType2] = PDefined.mainColor
        summaryLabel.customSelectedColor[customType1] = PDefined.mainColor
        summaryLabel.customSelectedColor[customType2] = PDefined.mainColor
        summaryLabel.handleCustomTap(for: customType1) { [weak self] element in
            self?.showTerms(.privacy)
        }
        summaryLabel.handleCustomTap(for: customType2) { [weak self] element in
            self?.showTerms(.term)
        }
        summaryLabel.text = "Bằng việc nhấn vào tiếp tục là bạn đã đồng ý với chính sách và điều khoản của PowerSteam"
    }
    
    
    private func initData() {
        agreeButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.agreeButton.isSelected = !self.agreeButton.isSelected
                self.viewModel.enableConfirm.accept(self.agreeButton.isSelected)
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                PAppManager.shared.acceptedAgreement = true
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper

extension AgreementVC {
    
    
}

// MARK: - Navigation

extension AgreementVC {
    
    func showTerms(_ agreementType: AgreementType) {
        let termsVC = TermsVC(agreementType)
        navigationController?.pushViewController(termsVC, animated: true)
    }
}




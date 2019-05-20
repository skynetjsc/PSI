//
//  TermsVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class TermsVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: TermsVM!
    
    init(_ agreementType: AgreementType) {
        viewModel = TermsVM(agreementType)
        super.init(nibName: "TermsVC", bundle: nil)
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

extension TermsVC {
    
    private func initComponent() {
        //navigationBar.hideLeftButton()
        
    }
    
    
    private func initData() {
        viewModel.titleStr.asDriver().drive(self.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.contentStr.asDriver().drive(self.contentTextView.rx.text).disposed(by: disposeBag)
    }
}




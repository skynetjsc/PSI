//
//  CouponDetailVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CouponDetailVC: UIViewController {
    
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - Variable
    private let disposeBag = DisposeBag()
    var viewModel: CouponDetailVM!
    
    init(_ promotionModel: PPromotionModel) {
        viewModel = CouponDetailVM(promotionModel)
        super.init(nibName: "CouponDetailVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        bindData()
    }
}

// MARK: - Initialization

extension CouponDetailVC {
    
    private func initComponent() {
        viewModel.getPromotionDetail { (code, message) in
            if code > 0 {
                // write code here
            } else {
                AppMessagesManager.shared.showMessage(messageType: .error, withTitle: "", message: message, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        copyButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                AppMessagesManager.shared.showToastView("Copied!".localized())
                UIPasteboard.general.string = self.viewModel.codeStr.value 
            })
            .disposed(by: disposeBag)
    }
    
    private func bindData() {
        viewModel.titleStr.asDriver().drive(self.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.codeStr.asDriver().drive(self.codeLabel.rx.text).disposed(by: disposeBag)
        viewModel.contentStr.asDriver().drive(self.contentLabel.rx.text).disposed(by: disposeBag)
        viewModel.timeStr.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
    }
}





//
//  FeedbackDetailVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class FeedbackDetailVC: UIViewController {
    
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var responseLabel: UILabel!
    
    // MARK: - Variable
    private let disposeBag = DisposeBag()
    var viewModel: FeedbackDetailVM!
    
    init(_ feedbackModel: PFeedbackModel) {
        viewModel = FeedbackDetailVM(feedbackModel)
        super.init(nibName: "FeedbackDetailVC", bundle: nil)
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

extension FeedbackDetailVC {
    
    private func initComponent() {
        viewModel.getFeedbackDetail { (code, message) in
            if code > 0 {
                // write code here
            } else {
                AppMessagesManager.shared.showMessage(messageType: .error, withTitle: "", message: message, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    private func bindData() {
        viewModel.timeStr.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.typeStr.asDriver().drive(self.typeLabel.rx.text).disposed(by: disposeBag)
        viewModel.contentStr.asDriver().drive(self.contentLabel.rx.text).disposed(by: disposeBag)
    }
}

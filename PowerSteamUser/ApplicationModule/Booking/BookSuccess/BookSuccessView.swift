//
//  BookSuccessView.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftMessages
import UIKit

class BookSuccessView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var starView: AStarView!
    @IBOutlet weak var amountPaymentLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: BookSuccessViewModel? {
        didSet {
            bindData()
        }
    }
    var confirmCompletion: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        starView.isInteractive = true
        starView.starType = .large
        starView.setStarActive(numberOfStar: 1)
        starView.observerReviewAction = { [weak self] number in
            guard let `self` = self else { return }
            
        }
        
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                SwiftMessages.hideAll()
                self?.confirmCompletion?()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindData() {
        
    }
    
}

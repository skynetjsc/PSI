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
        starView.setStarActive(numberOfStar: 0)
        starView.observerReviewAction = { [weak self] number in
            guard let `self` = self else { return }
            self.viewModel?.rating.accept(number)
        }
        
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self, let viewModel = self.viewModel else { return }
                viewModel.rating(completion: { (code, message) in
                    if code > 0 {
                        AppMessagesManager.shared.bookSuccessSwiftMessage.hide()
                        self.confirmCompletion?()
                    } else {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                    }
                })  
            })
            .disposed(by: disposeBag)
    }
    
    private func bindData() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.timeStr.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.techAvararLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.avatarImage.kf.setImage(with: url, placeholder: PDefined.noAvatar, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        viewModel.techName.asDriver().drive(self.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.priceStr.asDriver().drive(self.amountPaymentLabel.rx.text).disposed(by: disposeBag)
        viewModel.enableConfirm.asDriver().drive(self.confirmButton.rx.isEnabled).disposed(by: disposeBag)
    }
}





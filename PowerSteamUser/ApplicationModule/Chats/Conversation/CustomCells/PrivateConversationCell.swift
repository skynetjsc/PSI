//
//  PrivateConversationCell.swift
//  LianChat
//
//  Created by Mac on 1/15/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import SwipeCellKit
import UIKit

class PrivateConversationCell: SwipeTableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var divView: UIView!
    
    static let cellIdentifier = "PrivateConversationCell"
    var disposeBag = DisposeBag()
    var viewModel: ConversationCellVM? {
        didSet {
            bindData()
        }
    }
    var avatarClickBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialization()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        initialization()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func avatarDidClick(_ sender: UIButton) {
        self.avatarClickBlock?()
    }
}

// MARK: - Helper

extension PrivateConversationCell {
    
    private func initialization() {
        nameLabel.text = ""
        messageLabel.text = ""
        timeLabel.text = ""
        avatarImage.image = PDefined.noAvatar
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.avatarLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.avatarImage.kf.setImage(with: url, placeholder: PDefined.noAvatar, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        viewModel.isOnline.asDriver()
            .drive(onNext: { [weak self] (isOnline) in
                self?.onlineView.backgroundColor = isOnline ? PDefined.onlineColor : PDefined.offlineColor
            })
            .disposed(by: disposeBag)
        viewModel.nameStr.asDriver().drive(self.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.lastMessage.asDriver().drive(self.messageLabel.rx.text).disposed(by: disposeBag)
        viewModel.timeUpdated.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
    }
}






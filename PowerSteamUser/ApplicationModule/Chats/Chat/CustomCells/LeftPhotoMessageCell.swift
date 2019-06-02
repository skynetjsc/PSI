//
//  LeftPhotoMessageCell.swift
//  LianChat
//
//  Created by Mac on 1/17/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class LeftPhotoMessageCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var onlineView: UIView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    static let cellIdentifier = "LeftPhotoMessageCell"
    var disposeBag = DisposeBag()
    var viewModel: MessageCellVM? {
        didSet {
            bindData()
        }
    }
    var isCirclebg: Bool? {
        didSet {
            bgImage.image = UIImage(named: isCirclebg ?? false ? "top-left-chat-bg" : "left-chat-bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 16, left: 20, bottom: 17, right: 20), resizingMode: .stretch)
        }
    }
    var avatarClickBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        initialization()
        bgImage.image = UIImage(named: "left-chat-bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 16, left: 20, bottom: 17, right: 20), resizingMode: .stretch)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        initialization()
    }
    
    @IBAction func avatarDidClick(_ sender: UIButton) {
        self.avatarClickBlock?()
    }
}

// MARK: - Helper

extension LeftPhotoMessageCell {
    
    private func initialization() {
        timeLabel.text = ""
        avatarImage.image = PDefined.noAvatar
        imageview.image = PDefined.placeholderImage
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.techAvatarLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.avatarImage.kf.setImage(with: url, placeholder: PDefined.noAvatar, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        viewModel.imageLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.imageview.kf.setImage(with: url, placeholder: PDefined.placeholderImage, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        viewModel.isOnline.asDriver()
            .drive(onNext: { [weak self] (isOnline) in
                self?.onlineView.backgroundColor = isOnline ? PDefined.onlineColor : PDefined.offlineColor
            })
            .disposed(by: disposeBag)
        viewModel.timeStr.asDriver()
            .drive(onNext: { [weak self] (timeStr) in
                self?.timeLabel.text = timeStr
                self?.timeLabel.isHidden = timeStr.isEmpty
            })
            .disposed(by: disposeBag)
    }
}




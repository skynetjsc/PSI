//
//  RightFileMessageCell.swift
//  LianChat
//
//  Created by Mac on 1/17/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import ActiveLabel
import RxCocoa
import RxSwift
import UIKit

class RightFileMessageCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: PCopyableLabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    static let cellIdentifier = "RightFileMessageCell"
    var disposeBag = DisposeBag()
    var viewModel: MessageCellVM? {
        didSet {
            bindData()
        }
    }
    var isCirclebg: Bool? {
        didSet {
            bgImage.image = UIImage(named: isCirclebg ?? false ? "top-right-chat-bg" : "right-chat-bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 16, left: 20, bottom: 17, right: 20), resizingMode: .stretch)
        }
    }
    
    deinit {
        AudioManager.shared.stopPlay()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        initialization()
        bgImage.image = UIImage(named: "right-chat-bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 16, left: 20, bottom: 17, right: 20), resizingMode: .stretch)
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
}

// MARK: - Helper

extension RightFileMessageCell {
    
    private func initialization() {
        timeLabel.text = ""
        messageLabel.text = ""
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.fileStr.asDriver()
            .drive(onNext: { [weak self] (text) in
                guard let `self` = self else { return }
                //let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
                //let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
                self.messageLabel.text = text
                //self.messageLabel.attributedText = underlineAttributedString
            })
            .disposed(by: disposeBag)
        
        viewModel.timeStr.asDriver()
            .drive(onNext: { [weak self] (timeStr) in
                self?.timeLabel.text = timeStr
                self?.timeLabel.isHidden = timeStr.isEmpty
            })
            .disposed(by: disposeBag)
        
        viewModel.statusImage.asDriver().drive(self.imageview.rx.image).disposed(by: disposeBag)
    }
    /*
    func handleTapLink() {
        guard let viewModel = viewModel else { return }
        if viewModel.message.contentTypeEnum == .audio {
            if AudioManager.shared.fileName == viewModel.message.file {
                if let audioPlayer = AudioManager.shared.audioPlayer {
                    if audioPlayer.isPlaying {
                        AudioManager.shared.pausePlay()
                    } else {
                        AudioManager.shared.resumePlay()
                    }
                    viewModel.isPlaying.accept(audioPlayer.isPlaying)
                } else {
                    AudioManager.shared.playSound()
                    viewModel.isPlaying.accept(true)
                }
            } else {
                AudioManager.shared.setupPlay(urlString: viewModel.message.file)
                AudioManager.shared.playSound()
                viewModel.isPlaying.accept(true)
                AudioManager.shared.failedPlay = { [weak self] message in
                    viewModel.isPlaying.accept(false)
                    self?.openURL(urlString: viewModel.message.file)
                }
            }
            AudioManager.shared.didFinishPlaying = { [weak self] in
                viewModel.isPlaying.accept(false)
            }
        } else {
            openURL(urlString: viewModel.message.file)
        }
    }
    
    func openURL(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    */
}









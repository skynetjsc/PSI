//
//  FeedbackCell.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class FeedbackCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    static let cellIdentifier = "FeedbackCell"
    var disposeBag = DisposeBag()
    var viewModel: FeedbackCellVM? {
        didSet {
            bindData()
        }
    }
    
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
}

// MARK: - Helper

extension FeedbackCell {
    
    private func initialization() {
        timeLabel.text = ""
        titleLabel.text = ""
        addressLabel.text = ""
        statusLabel.text = ""
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.timeStr.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.titleStr.asDriver().drive(self.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.addressStr.asDriver().drive(self.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.status.asDriver()
            .drive(onNext: { [weak self] (status) in
                if status > 0 {
                    self?.statusLabel.text = "Đã giải quyết".localized()
                    self?.statusLabel.textColor = PDefined.mainColor
                    self?.statusImage.isHidden = false
                    self?.typeImage.image = #imageLiteral(resourceName: "resolved-icon")
                } else {
                    self?.statusLabel.text = "Chờ phản hồi".localized()
                    self?.statusLabel.textColor = PDefined.redColor
                    self?.statusImage.isHidden = true
                    self?.typeImage.image = #imageLiteral(resourceName: "recieved-icon")
                }
            })
            .disposed(by: disposeBag)
    }
}






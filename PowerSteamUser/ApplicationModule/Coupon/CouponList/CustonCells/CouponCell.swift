//
//  CouponCell.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CouponCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    
    static let cellIdentifier = "CouponCell"
    var disposeBag = DisposeBag()
    var viewModel: CouponCellVM? {
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

extension CouponCell {
    
    private func initialization() {
        timeLabel.text = ""
        titleLabel.text = ""
        contentLabel.text = ""
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.timeStr.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.titleStr.asDriver().drive(self.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.contentStr.asDriver().drive(self.contentLabel.rx.text).disposed(by: disposeBag)
        viewModel.isRead.asDriver()
            .drive(onNext: { [weak self] (isRead) in
                self?.statusView.isHidden = isRead
                self?.containerView.backgroundColor = UIColor(hexString: isRead ? "FFFFFF" : "B8E986")
            })
            .disposed(by: disposeBag)
    }
}






//
//  PeriodServiceCell.swift
//  PowerSteamUser
//
//  Created by Mac on 5/25/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PeriodServiceCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    static let cellIdentifier = "PeriodServiceCell"
    var disposeBag = DisposeBag()
    var viewModel: PeriodServiceCellVM? {
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

extension PeriodServiceCell {
    
    private func initialization() {
        titleLabel.text = ""
        timeLabel.text = ""
        addressLabel.text = ""
        statusLabel.text = ""
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.titleStr.asDriver().drive(self.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.timeStr.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.addressStr.asDriver().drive(self.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.statusStr.asDriver().drive(self.statusLabel.rx.text).disposed(by: disposeBag)
        viewModel.statusColor.asDriver()
            .drive(onNext: { [weak self] (color) in
                self?.statusLabel.textColor = color
                self?.statusView.backgroundColor = color
            })
            .disposed(by: disposeBag)
    }
}







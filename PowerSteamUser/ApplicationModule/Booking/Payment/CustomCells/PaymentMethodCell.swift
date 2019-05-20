//
//  PaymentMethodCell.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PaymentMethodCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    static let cellIdentifier = "PaymentMethodCell"
    var disposeBag = DisposeBag()
    var viewModel: PaymentMethodCellVM? {
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

extension PaymentMethodCell {
    
    private func initialization() {
        titleLabel.text = ""
        valueLabel.text = ""
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.isSelected.asDriver()
            .drive(onNext: { [weak self] (isSelected) in
                guard let self = self else { return }
                self.selectButton.isSelected = isSelected
                
            })
            .disposed(by: disposeBag)
        
        titleLabel.text = viewModel.model.name
        valueLabel.isHidden = true
        
    }
}





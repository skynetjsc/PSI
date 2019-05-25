//
//  ServiceHistoryCell.swift
//  PowerSteamUser
//
//  Created by Mac Mini on 5/22/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ServiceHistoryCell: UITableViewCell {
    
    // MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    static let cellIdentifier = "ServiceHistoryCell"
    var disposeBag = DisposeBag()
    var viewModel: ServiceHistoryCellVM? {
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

extension ServiceHistoryCell {
    
    private func initialization() {
        serviceImage.image = PDefined.placeholderImage
        nameLabel.text = ""
        timeLabel.text = ""
        priceLabel.text = ""
        statusLabel.text = ""
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.imageLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.serviceImage.kf.setImage(with: url, placeholder: PDefined.placeholderImage, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.nameStr.asDriver().drive(self.nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.timeStr.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.priceStr.asDriver().drive(self.priceLabel.rx.text).disposed(by: disposeBag)
        viewModel.statusStr.asDriver().drive(self.statusLabel.rx.text).disposed(by: disposeBag)
        viewModel.statusColor.asDriver()
            .drive(onNext: { [weak self] (color) in
                self?.statusLabel.textColor = color
            })
            .disposed(by: disposeBag)
    }
}





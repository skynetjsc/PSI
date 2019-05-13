//
//  ServiceListCell.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ServiceListCell: UITableViewCell {

    // MARK: - Outlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var serviceImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let cellIdentifier = "ServiceListCell"
    var disposeBag = DisposeBag()
    var viewModel: ServiceListCellVM? {
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

extension ServiceListCell {
    
    private func initialization() {
//        serviceImage.image = PDefined.placeholderImage
//        nameLabel.text = ""
//        descriptionLabel.text = ""
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
        viewModel.description.asDriver().drive(self.descriptionLabel.rx.text).disposed(by: disposeBag)
    }
}




//
//  BookProcessingView.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftMessages
import UIKit

class BookProcessingView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var packageItemStackView: UIStackView!
    @IBOutlet weak var moreStackView: UIStackView!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var paymentTypeLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var viewModel: BookProcessingViewModel? {
        didSet {
            bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        // write code here
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
        viewModel.rateStr.asDriver().drive(self.rateLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.serviceImageLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.packageImage.kf.setImage(with: url, placeholder: PDefined.placeholderImage, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        viewModel.serviceName.asDriver().drive(self.packageName.rx.text).disposed(by: disposeBag)
        viewModel.promotionStr.asDriver().drive(self.promotionLabel.rx.text).disposed(by: disposeBag)
        viewModel.paymentStr.asDriver().drive(self.paymentTypeLabel.rx.text).disposed(by: disposeBag)
        viewModel.serviceItems.asDriver()
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                // add item views
                list.forEach { (item) in
                    let itemView = PackageItemView()
                    itemView.setupData(name: item.title)
                    itemView.nameLabel.textColor = UIColor.white
                    self.packageItemStackView.addArrangedSubview(itemView)
                }
            })
            .disposed(by: disposeBag)
    }
}






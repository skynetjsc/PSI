//
//  BookOnWayView.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftMessages
import UIKit

class BookOnWayView: UIView {
    
    @IBOutlet weak var inforView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    @IBOutlet weak var vehicleName: UILabel!
    
    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    let disposeBag = DisposeBag()
    var viewModel: BookOnWayViewModel? {
        didSet {
            bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        callButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self, let viewModel = self.viewModel, let number = viewModel.bookModel.tech?.phone else { return }
                guard let numberUrl = URL(string: "tel://" + number) else { return }
                UIApplication.shared.open(numberUrl)
            })
            .disposed(by: disposeBag)
        
        chatButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                self.showChatVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindData() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.statusStr.asDriver().drive(self.statusLabel.rx.text).disposed(by: disposeBag)
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
        viewModel.servicePrice.asDriver().drive(self.packagePrice.rx.text).disposed(by: disposeBag)
        
        viewModel.vehicleType.asDriver()
            .drive(onNext: { [weak self] (vehicleType) in
                guard let self = self else { return }
                self.vehicleName.text = vehicleType.name
                self.vehicleImage.image = vehicleType.image
            })
            .disposed(by: disposeBag)
        
        viewModel.paymentType.asDriver()
            .drive(onNext: { [weak self] (paymentType) in
                guard let self = self else { return }
                switch paymentType {
                case .cash:
                    self.cardName.text = paymentType.content
                    self.cardNumber.isHidden = true
                    self.cardImage.isHidden = true
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Navigation
extension BookOnWayView {
    
    func showChatVC() {
        guard let viewModel = self.viewModel else { return }
        //SwiftMessages.hide()
        let chatVC = ChatVC(viewModel.bookModel.user?.id ?? 0, viewModel.bookModel.tech?.id ?? 0)
        chatVC.hidesBottomBarWhenPushed = true
        UIApplication.topVC()?.navigationController?.pushViewController(chatVC, animated: true)
    }
}






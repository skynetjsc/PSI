//
//  BookDetailVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/24/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class BookDetailVC: UIViewController {

    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var packageImage: UIImageView!
    @IBOutlet weak var packageName: UILabel!
    @IBOutlet weak var bookingIDLabel: UILabel!
    @IBOutlet weak var packagePrice: UILabel!
    @IBOutlet weak var itemsStackView: UIStackView!
    @IBOutlet weak var techView: UIView!
    @IBOutlet weak var techAvatar: UIImageView!
    @IBOutlet weak var techName: UILabel!
    @IBOutlet weak var techRate: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var imagesStackView: UIStackView!
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var complainView: UIView!
    @IBOutlet weak var complaintButton: UIButton!
    
    // MARK: - Variable
    private let disposeBag = DisposeBag()
    var viewModel: BookDetailVM!
    
    init(_ bookingID: Int) {
        viewModel = BookDetailVM(bookingID)
        super.init(nibName: "BookDetailVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initComponent()
        bindData()
    }
}

// MARK: - Initialization

extension BookDetailVC {
    
    private func initComponent() {
        tapActions()
        statusView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 4))
    }
    
    private func tapActions() {
        complaintButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.showNewFeedback()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindData() {
        viewModel.getBookingDetail { (code, message) in
            if code > 0 {
                // write code here
            } else {
                AppMessagesManager.shared.showMessage(messageType: .error, message: message, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        viewModel.timeStr.asDriver().drive(self.navigationBar.titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.serviceName.asDriver().drive(self.packageName.rx.text).disposed(by: disposeBag)
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
        viewModel.bookingIDStr.asDriver().drive(self.bookingIDLabel.rx.text).disposed(by: disposeBag)
        viewModel.servicePrice.asDriver().drive(self.packagePrice.rx.text).disposed(by: disposeBag)
        viewModel.serviceItems.asDriver()
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                // add item views
                list.forEach { (item) in
                    let itemView = BookPackageItemView()
                    itemView.setupData(name: item.title)
                    self.itemsStackView.addArrangedSubview(itemView)
                }
            })
            .disposed(by: disposeBag)
        viewModel.bookActiveType.asDriver()
            .drive(onNext: { [weak self] (bookActiveType) in
                guard let self = self else { return }
                if bookActiveType == .completed {
                    self.statusLabel.text = "Đã hoàn thành".localized()
                    self.statusLabel.textColor = PDefined.mainColor
                    self.statusImage.image = #imageLiteral(resourceName: "completed-bg")
                    self.complainView.isHidden = false
                } else {
                    self.statusLabel.text =  "Đã huỷ".localized()
                    self.statusLabel.textColor = PDefined.redColor
                    self.statusImage.image = #imageLiteral(resourceName: "canceled-bg")
                    self.complainView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        viewModel.techAvararLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.techAvatar.kf.setImage(with: url, placeholder: PDefined.noAvatar, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        viewModel.techName.asDriver().drive(self.techName.rx.text).disposed(by: disposeBag)
        viewModel.techRate.asDriver().drive(self.techRate.rx.text).disposed(by: disposeBag)
        viewModel.isHiddenTech.asDriver().drive(self.techView.rx.isHidden).disposed(by: disposeBag)
        viewModel.addressStr.asDriver().drive(self.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.isHiddenImages.asDriver()
            .drive(onNext: { [weak self] (isHiddenImages) in
                self?.imagesView.isHidden = isHiddenImages
                self?.noteView.isHidden = isHiddenImages
            })
            .disposed(by: disposeBag)
        viewModel.images.asDriver()
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                for (index, item) in list.enumerated() {
                    let buttonImage = PButton(frame: CGRect(x: 0, y: 0, width: 68, height: 60))
                    buttonImage.setImage(#imageLiteral(resourceName: "photo-border"), for: .normal)
                    buttonImage.contentMode = .scaleAspectFill
                    buttonImage.cornerRadius = 6.0
                    if let url = URL(string: item.image.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
                        buttonImage.kf.setImage(with: url, for: .normal, placeholder: #imageLiteral(resourceName: "photo-border"), options: nil, progressBlock: nil, completionHandler: nil)
                    }
                    self.imagesStackView.addArrangedSubview(buttonImage)
                    buttonImage.snp.makeConstraints({ (make) in
                        make.width.equalTo(68.0)
                        make.height.equalTo(60.0)
                    })
                    buttonImage.rx.tap.asDriver()
                        .throttle(1)
                        .drive(onNext: { [weak self] in
                            if let `self` = self {
                                self.showSlideImages(index)
                            }
                        })
                        .disposed(by: self.viewModel.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension BookDetailVC {
    
    func showSlideImages(_ index: Int) {
        let slideShowVC = PSlideShowVC(listImages: self.viewModel.images.value, currentIndex: index)
        self.present(slideShowVC, animated: true, completion: nil)
    }
    
    func showNewFeedback() {
        let newFeedbackVC = NewFeedbackVC()
        navigationController?.pushViewController(newFeedbackVC, animated: true)
    }
}



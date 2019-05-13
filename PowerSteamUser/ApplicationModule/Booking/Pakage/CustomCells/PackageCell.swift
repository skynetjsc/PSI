//
//  PackageCell.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class PackageCell: UICollectionViewCell {

    // MARK: - Outlet
    @IBOutlet weak var containerView: PView!
    @IBOutlet weak var packageImage: UIImageView!
    
    static let cellIdentifier = "PackageCell"
    var disposeBag = DisposeBag()
    var viewModel: PackageCellVM? {
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
}

// MARK: - Helper

extension PackageCell {
    
    private func initialization() {
        packageImage.image = #imageLiteral(resourceName: "drops")
        viewModel?.isSelected.accept(false)
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.imageLink.asDriver()
            .filter { $0.count > 0 }
            .map { URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] (url) in
                if let url = url {
                    self?.packageImage.kf.setImage(with: url, placeholder: PDefined.placeholderImage, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isSelected.asDriver()
            .drive(onNext: { [weak self] (isSelected) in
                guard let self = self else { return }
                self.packageImage.image = isSelected ? #imageLiteral(resourceName: "drops1") : #imageLiteral(resourceName: "drops")
                self.containerView.borderWidth = isSelected ? 1.5 : 0.0
            })
            .disposed(by: disposeBag)
    }
}




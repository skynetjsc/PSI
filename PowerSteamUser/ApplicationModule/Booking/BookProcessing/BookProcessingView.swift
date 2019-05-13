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
    
    @IBOutlet weak var packageItemStackView: UIStackView!
    @IBOutlet weak var moreStackView: UIStackView!
    
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
        (1...4).forEach { (item) in
            let item = PackageItemView()
            item.nameLabel.textColor = UIColor.white
            self.packageItemStackView.addArrangedSubview(item)
        }
    }
    
    private func bindData() {
        
    }
}

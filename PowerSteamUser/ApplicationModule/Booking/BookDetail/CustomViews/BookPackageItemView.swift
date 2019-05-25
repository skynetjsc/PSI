//
//  BookPackageItemView.swift
//  PowerSteamUser
//
//  Created by Mac on 5/24/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class BookPackageItemView: UIView {
    
    let nibName = "BookPackageItemView"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var divView: UIView!
    
    fileprivate let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.clear
    }
    
    func setupData(name: String) {
        nameLabel.text = name
    }
}

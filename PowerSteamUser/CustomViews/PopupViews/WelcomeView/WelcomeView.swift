//
//  WelcomeView.swift
//  Receigo
//
//  Created by Mac on 12/26/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftMessages
import UIKit

class WelcomeView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel: WelcomeViewModel? {
        didSet {
            bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindData()
    }
    
    private func bindData() {
        closeButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: {
                SwiftMessages.hideAll()
            })
            .disposed(by: disposeBag)
    }
}

//
//  BookingConfirmView.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftMessages
import UIKit

class BookingConfirmView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    let disposeBag = DisposeBag()
    var confirmCompletion: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                SwiftMessages.hideAll()
                self?.confirmCompletion?()
            })
            .disposed(by: disposeBag)
    }
}

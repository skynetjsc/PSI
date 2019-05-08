//
//  ReasonRejectView.swift
//  HRM_App
//
//  Created by Mac on 3/4/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftMessages
import UIKit

class ReasonRejectView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var textView: KMPlaceholderTextView!
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!

    let disposeBag = DisposeBag()
    var confirmCompletion: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        // setup textview
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 8, right: 8)
        textView.textContainer.maximumNumberOfLines = 50
        textView.textContainer.lineBreakMode = .byTruncatingTail
        textView.rx.didChange.subscribe(onNext: { [weak self] n in
            guard let `self` = self else { return }
            
            let height = self.textView.contentSize.height
            self.heightTextView.constant = max(35.0, height)
            if height > 35 {
                self.heightTextView.constant = min(100.0, height)
            }
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }).disposed(by: disposeBag)
        
        leftButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: {
                SwiftMessages.hideAll()
            })
            .disposed(by: disposeBag)
        
        rightButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                let content = self?.textView.text ?? ""
                if content.count == 0 {
                    self?.textView.becomeFirstResponder()
                    return
                }
                SwiftMessages.hideAll()
                self?.confirmCompletion?(content)
            })
            .disposed(by: disposeBag)
    }
}

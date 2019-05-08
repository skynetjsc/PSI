//
//  ImageItem.swift
//  LianChat
//
//  Created by Mac on 1/29/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class ImageItem: UIView {

    let nibName = "ImageItem"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    fileprivate let disposeBag = DisposeBag()
    var closeActionBlock: (() -> Void)?
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
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
        contentView.backgroundColor = UIColor.white
        
        closeButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.closeActionBlock?()
                }
            })
            .disposed(by: disposeBag)
    }
}

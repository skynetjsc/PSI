//
//  PlaceItem.swift
//  LianChat
//
//  Created by Mac on 1/29/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import UIKit

class PlaceItem: UIView {

    let nibName = "PlaceItem"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var gradientView: PGradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var isSelected: Bool = true {
        didSet {
            self.gradientView.isHidden = !isSelected
        }
    }
    var placeID: String = ""
    var didActionClickBlock: (() -> Void)?
    
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
    }
    
    @IBAction func actionButtonDidClick(_ sender: UIButton) {
        self.isSelected = !self.isSelected
        self.didActionClickBlock?()
    }
}

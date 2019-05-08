//
//  PPhotoCell.swift
//  LianChat
//
//  Created by Mac on 1/20/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import UIKit

class PPhotoCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    
    static let cellIdentifier = "PPhotoCell"
    var sendButtonClickBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func sendButtonDidClick(_ sender: UIButton) {
        self.sendButtonClickBlock?()
    }
}

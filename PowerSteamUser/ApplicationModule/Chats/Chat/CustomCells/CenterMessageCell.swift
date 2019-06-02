//
//  CenterMessageCell.swift
//  LianChat
//
//  Created by Mac on 2/24/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class CenterMessageCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    static let cellIdentifier = "CenterMessageCell"
    var disposeBag = DisposeBag()
    var viewModel: MessageCellVM? {
        didSet {
            bindData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        initialization()
    }
}

// MARK: - Helper

extension CenterMessageCell {
    
    private func initialization() {
        titleLabel.text = ""
    }
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.messageStr.asDriver().drive(self.titleLabel.rx.text).disposed(by: disposeBag)
    }
}



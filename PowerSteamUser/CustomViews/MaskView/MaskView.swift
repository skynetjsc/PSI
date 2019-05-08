//
//  MaskView.swift
//  WeWorld
//
//  Created by NhatQuang on 2/8/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import SnapKit
import UIKit


class MaskView: UIView {
	init() {
		super.init(frame: CGRect.zero)
		backgroundColor = UIColor.white.withAlphaComponent(0.7)
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}


// MARK: - Setup
extension UIView {
	func addMaskView(withLoadingActivity isLoading: Bool = false) {
		// Add mask view
		let maskView = MaskView()
		self.addSubview(maskView)
		maskView.snp.makeConstraints { (constraint) in
			constraint.top.left.bottom.right.equalToSuperview()
		}
		// Add loading if need
		if isLoading {
            let loading = UIActivityIndicatorView(style: .gray)
			loading.startAnimating()
			maskView.addSubview(loading)
			loading.snp.makeConstraints({ (constraint) in
				constraint.center.equalToSuperview()
			})
		}
	}
	
	func removeMaskView() {
		self.subviews.forEach { (uiview) in
			uiview.isKind(of: MaskView.self) ? uiview.removeFromSuperview() : nil
		}
	}
}














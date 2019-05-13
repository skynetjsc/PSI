//
//  AStarView.swift
//  anytime
//
//  Created by NhatQuang on 1/29/18.
//

import Foundation
import UIKit

class AStarView: UIView {
	
	let nibName = "AStarView"
	@IBOutlet weak var contentView: UIView!
	@IBOutlet var listStars: [UIButton]!
	
	// MARK: - Action
	@IBAction func starDidClicked(_ sender: UIButton) {
		guard isInteractive else { return }
		listStars.forEach { (starButton) in
			starButton.isSelected = starButton.tag <= sender.tag
			starButton.imageView?.tintColor = starButton.isSelected ? starType.activeColor : starType.inactiveColor
			starButton.isSelected ? starButton.pulsate() : nil
		}
		observerReviewAction?(ratedNumber)
	}
	
	
	// MARK: - Variable
	var starType: StarType = .small {
		didSet {
			listStars.forEach { (starButton) in
				starButton.setImage(starType.image.withRenderingMode(.alwaysTemplate), for: .normal)
			}
		}
	}
	
	/// Allow rate or not
	var isInteractive: Bool = false {
		didSet {
			listStars.forEach { (starButton) in
				starButton.isUserInteractionEnabled = isInteractive
			}
		}
	}
	
	/// Number of rated star
	var ratedNumber: Int {
		var numberOfRate: Int = 0
		listStars.forEach { (starButton) in
			numberOfRate += starButton.isSelected ? 1 : 0
		}
		return numberOfRate
	}
	
	var observerReviewAction: ((Int) -> Void)?
	
	
	
	// MARK: - Init
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
		isInteractive = false
		starType = .small
        setStarActive(numberOfStar: 0)
	}
}



// MARK: - Useful function
extension AStarView {
	func setStarActive(numberOfStar: Int) {
		listStars.forEach { (starButton) in
			starButton.isSelected = starButton.tag < numberOfStar
			starButton.tintColor = starButton.isSelected ? starType.activeColor : starType.inactiveColor
		}
	}
}

























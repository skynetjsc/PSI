//
//  NavigationView.swift
//  anecel
//
//  Created by NhatQuang on 3/15/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class NavigationView: UIView {
	
    let nibName = "NavigationView"
    
	@IBOutlet weak var contentView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var leftButtonsStack: UIStackView!
    @IBOutlet weak var rightButtonsStack: UIStackView!
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
	
	var customBackAction: (() -> Void)?
	
	private func setup() {
		Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
		addSubview(contentView)
		contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.clear
        titleLabel.textColor = PDefined.headerTintColor
        divView.isHidden = true
        
        // add backbutton
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        //backButton.setImage(#imageLiteral(resourceName: "arrow-right").withRenderingMode(.alwaysTemplate), for: .normal)
        //backButton.tintColor = PDefined.headerTintColor
        backButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
				if let customBackAction = self?.customBackAction {
					customBackAction()
				} else {
                    if let topVC = UIApplication.topVC() {
                        guard let slideMenuController = topVC as? SlideMenuController else {
                            self?.backClick(from: topVC)
                            return
                        }
                        
                        guard let mainVC = slideMenuController.mainViewController else {
                            topVC.dismiss(animated: true, completion: nil)
                            return
                        }
                        
                        self?.backClick(from: mainVC)
                    }
				}
            })
            .disposed(by: disposeBag)
        
        backButton.snp.makeConstraints { (make) in
            make.width.equalTo(44)
        }
        leftButtonsStack.addArrangedSubview(backButton)
	}
    
    func backClick(from viewController: UIViewController) {
        guard let navi = viewController as? UINavigationController else {
            guard let navi = viewController.navigationController else {
                viewController.dismiss(animated: true, completion: nil)
                return
            }
            
            guard navi.viewControllers.count > 1 else {
                navi.dismiss(animated: true, completion: nil)
                return
            }
            
            navi.popViewController(animated: true)
            return
        }
        navi.popViewController(animated: true)
    }
}

// MARK: - Setup view

extension NavigationView {
    
    /// setup view for navigation view
    ///
    /// - Parameters:
    ///   - title: title of navigation view
    ///   - imageIcon: image icon for navigation view
    ///   - leftButton: custom left button for navigation view, default is back button
    ///   - rightButtons: right buttons for navigation view
    func setupView(title: String? = nil, imageIcon: UIImage? = nil, leftButtons: [UIButton]? = nil, rightButtons: [UIButton]? = nil) {
        self.titleLabel.text = title
        self.imageView.image = imageIcon
        self.imageView.isHidden = imageIcon == nil
        
        if let leftButtons = leftButtons {
            // remove all subviews
            leftButtonsStack.arrangedSubviews.forEach { (view) in
                leftButtonsStack.removeArrangedSubview(view)
            }
            leftButtonsStack.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            
            // add left buttons
            leftButtons.forEach { (button) in
                leftButtonsStack.addArrangedSubview(button)
            }
        }
        
        if let rightButtons = rightButtons {
            rightButtons.forEach { (button) in
                rightButtonsStack.addArrangedSubview(button)
            }
        }
    }
    
    func setupView(title: String? = nil, imageIcon: UIImage? = nil, leftViews: [UIView]? = nil, rightViews: [UIView]? = nil) {
        self.titleLabel.text = title
        self.imageView.image = imageIcon
        self.imageView.isHidden = imageIcon == nil
        
        if let leftViews = leftViews {
            // remove all subviews
            leftButtonsStack.arrangedSubviews.forEach { (view) in
                leftButtonsStack.removeArrangedSubview(view)
            }
            leftButtonsStack.subviews.forEach { (view) in
                view.removeFromSuperview()
            }
            
            // add left buttons
            leftViews.forEach { (view) in
                leftButtonsStack.addArrangedSubview(view)
            }
        }
        
        if let rightViews = rightViews {
            rightViews.forEach { (view) in
                rightButtonsStack.addArrangedSubview(view)
            }
        }
    }
    
    func hideLeftButton() {
        // remove all subviews
        leftButtonsStack.arrangedSubviews.forEach { (view) in
            leftButtonsStack.removeArrangedSubview(view)
        }
        leftButtonsStack.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
}

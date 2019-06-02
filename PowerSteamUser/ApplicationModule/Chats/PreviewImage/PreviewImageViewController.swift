//
//  PreviewImageViewController.swift
//  headling
//
//  Created by NhatQuang on 5/17/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Hero
import UIKit
import RxCocoa
import RxSwift

class PreviewImageViewController: UIViewController {
	
	// MARK: - Outlet
    @IBOutlet weak var heroView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	// MARK: - Variable
	let disposeBag = DisposeBag()
	var viewModel: PreviewImageViewModel
	
	@IBAction func closeAction(_ sender: UIButton) {
		self.dismiss(animated: true, completion: nil)
	}
	
	// MARK: - Life cycle
	init(viewModel: PreviewImageViewModel) {
		self.viewModel = viewModel
		super.init(nibName: "PreviewImageViewController", bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initComponent()
		initData()
	}
}



// MARK: - Init function
extension PreviewImageViewController {
    
	func initComponent() {
		self.hero.isEnabled = true
	}
	
	func initData() {
        viewModel.imageLink.asDriver()
            .map({ URL(string: $0.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) })
            .drive(onNext: { [weak self] url in
                self?.imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.3))], progressBlock: nil, completionHandler: nil)
            })
            .disposed(by: disposeBag)
		
		viewModel.title.asDriver()
            .drive(onNext: { [weak self] (title) in
                if let title = title {
                    self?.titleLabel.text = title
                } else {
                    self?.titleLabel.isHidden = true
                }
            })
			.disposed(by: disposeBag)
		
        viewModel.description.asDriver()
            .drive(onNext: { [weak self] (description) in
                if let description = description {
                    self?.descriptionLabel.text = description
                } else {
                    self?.descriptionLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
		
		heroView.hero.id = viewModel.heroImageID
	}
}
























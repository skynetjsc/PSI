//
//  NewFeedbackVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/26/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import DropDown
import RxCocoa
import RxSwift
import UIKit

class NewFeedbackVC: UIViewController {
    
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var mediaButton: UIButton!
    @IBOutlet weak var feedbackTypeButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Variable
    private let disposeBag = DisposeBag()
    var viewModel: NewFeedbackVM!
    var mediaSource: PMediaSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        bindData()
    }
}

// MARK: - Initialization

extension NewFeedbackVC {
    
    private func initComponent() {
        viewModel = NewFeedbackVM()
        tapActions()
        
        // setup drowdown
        setupDropdown()
        
        // setup media source
        mediaSource = PMediaSource(sourceViewController: self, allowsEditing: true)
        mediaSource.handleTakedImage = { [weak self] newImage in
            guard let self = self else { return }
            let imageItem = ImageItem()
            imageItem.image = newImage
            self.viewModel.selectedImages.append(newImage)
            imageItem.closeActionBlock = { [weak self] in
                guard let `self` = self else { return }
                self.viewModel.selectedImages.removeAll(where: { (item) -> Bool in
                    return item == newImage
                })
                self.imageStackView.removeArrangedSubview(imageItem)
                imageItem.removeFromSuperview()
            }
            self.imageStackView.insertArrangedSubview(imageItem, at: 1)
        }
    }
    
    private func setupDropdown() {
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        
        let dropDown = DropDown()
        // The view to which the drop down will appear on
        dropDown.anchorView = self.feedbackTypeButton // UIView or UIBarButtonItem
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["Yêu cầu bồi thường"]
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.feedbackTypeButton.setTitle(item, for: .normal)
            self.viewModel.feedbackType.accept(item)
        }
        // Will set a custom width instead of the anchor view width
        //dropDown.width = 200
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        feedbackTypeButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    dropDown.show()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func tapActions() {
        timeButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.showDatePicker(title: "Thời điểm".localized(), initialDate: self.viewModel.time.value, minDate: Date(), mode: .dateAndTime, onDone: { [weak self] (date) in
                        self?.viewModel.time.accept(date)
                    })
                }
            })
            .disposed(by: disposeBag)
        
        mediaButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.mediaSource.showOption()
                }
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    if self.viewModel.address.value.isEmpty {
                        self.addressField.becomeFirstResponder()
                    }
                    if self.viewModel.contentStr.value.isEmpty {
                        self.descriptionTextView.becomeFirstResponder()
                    }
                    if self.viewModel.selectedImages.count == 0 {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: "Bạn cần nhập ít nhất 1 ảnh để tạo khiếu nại mới".localized())
                        return
                    }
                    
                    PLoadingActivity.shared.show(timeOut: TimeInterval(300)) // 5 minute
                    self.viewModel.createFeedback(completion: { (code, data) in
                        PLoadingActivity.shared.hide()
                        if code > 0 {
                            let message = "Tạo khiếu nại thành công".localized()
                            AppMessagesManager.shared.showMessage(messageType: .success, withTitle: "", message: message, completion: { [weak self] in
                                self?.showFeedbackList()
                                }, duration: .seconds(seconds: 2))
                        } else {
                            if let message = data as? String {
                                AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                            }
                        }
                    })
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindData() {
        addressField.rx.text.orEmpty.asDriver().drive(viewModel.address).disposed(by: disposeBag)
        descriptionTextView.rx.text.orEmpty.asDriver().drive(viewModel.contentStr).disposed(by: disposeBag)
        viewModel.time.asDriver()
            .drive(onNext: { [weak self] (time) in
                self?.timeLabel.text = time.convertTo(region: PDefined.serverRegion).toFormat("dd-MMM-yyyy HH:mm")
            }).disposed(by: disposeBag)
    }
}

// MARK: - Navigation

extension NewFeedbackVC {
    
    func showFeedbackList() {
        if let navi = self.navigationController {
            let feedbackListVC = FeedbackListVC()
            navi.pushViewController(feedbackListVC, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                var viewControllers = [UIViewController]()
                for viewController in navi.viewControllers {
                    if !viewController.isKind(of: NewFeedbackVC.self) {
                        viewControllers.append(viewController)
                    }
                }
                navi.viewControllers = viewControllers
            }
        }
    }
}

//
//  ChooseCarView.swift
//  PowerSteamUser
//
//  Created by Mac on 5/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftMessages
import UIKit

class ChooseCarView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bikeButton: UIButton!
    @IBOutlet weak var sedanButton: UIButton!
    @IBOutlet weak var suvButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    let disposeBag = DisposeBag()
    var confirmCompletion: (() -> Void)?
    let enableConfirm = BehaviorRelay<Bool>(value: false)
    var viewModel: ChooseCarViewModel? {
        didSet {
            bindData()
        }
    }
    var selectedVehicle: VehicleType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI() {
        enableConfirm.asDriver().drive(self.confirmButton.rx.isEnabled).disposed(by: disposeBag)
        
        for (index, senderButton) in [sedanButton, suvButton, bikeButton].enumerated() {
            senderButton!.rx.tap.asDriver()
                .throttle(1.0)
                .drive(onNext: { [weak self] in
                    senderButton?.pulsate()
                    if senderButton?.isSelected == false {
                        [self?.bikeButton, self?.sedanButton, self?.suvButton].forEach({ (item) in
                            item?.isSelected = false
                        })
                        senderButton?.isSelected = true
                        self?.enableConfirm.accept(true)
                        self?.selectedVehicle = VehicleType(rawValue: index + 1)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    private func bindData() {
        guard let viewModel = self.viewModel else { return }
        
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let self = self, let viewModel = self.viewModel else { return }
                let carName = self.textField.text ?? ""
                if carName.count == 0 {
                    self.textField.becomeFirstResponder()
                    return
                }
                let selectedVehicle = (self.selectedVehicle ?? .bike)
                viewModel.addCar(selectedVehicle.rawValue, carName, completion: { (code, message) in
                    if code > 0 {
                        SwiftMessages.hideAll()
                        self.confirmCompletion?()
                    } else {
                        AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                    }
                })
            })
            .disposed(by: disposeBag)
    }
}





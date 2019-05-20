//
//  ServicePackageVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import CoreLocation
import DropDown
import RxCocoa
import RxSwift
import SwiftDate
import UIKit

class ServicePackageVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var packageContentView: UIView!
    @IBOutlet weak var packageNameLabel: UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var itemsStackView: UIStackView!
    
    @IBOutlet weak var addressButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var repeatTypeLabel: UILabel!
    @IBOutlet weak var repeatTypeButton: UIButton!
    
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    // MARK: - Variable
    private let disposeBag = DisposeBag()
    private var viewModel: ServicePackageVM!
    let itemsDropDown = DropDown()
    
    init(_ address: String, _ location: CLLocation, _ typeBike: Int, _ serviceModel: PServiceModel) {
        viewModel = ServicePackageVM(address, location, typeBike, serviceModel)
        
        super.init(nibName: "ServicePackageVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        bindData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Initialization

extension ServicePackageVC {
    
    private func initComponent() {
        // setup collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: PackageCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PackageCell.cellIdentifier)
        
        // indicator view
        viewModel.shouldShowIndicatorView.asDriver()
            .drive(onNext: { [weak self] (isShow) in
                self?.collectionView.showIndicatorView(isShow: isShow)
            })
            .disposed(by: disposeBag)
        
        tapActions()
        setupDropDown()
    }
    
    private func tapActions() {
        hourButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.showDatePicker(title: "Thời gian giao hàng".localized(), initialDate: Date(), minDate: Date(), maxDate: nil, mode: .time, onDone: { [weak self] (date) in
                        guard let self = self else { return }
                        self.viewModel.hourWorking.accept(date.toFormat("HH:mm"))
                    }, onCancel: {
                        // write code here
                    })
                }
            })
            .disposed(by: disposeBag)
        
        dateButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.showDatePicker(title: "Chọn lịch dự tính".localized(), initialDate: Date(), minDate: Date(), maxDate: nil, mode: .date, onDone: { [weak self] (date) in
                        guard let self = self else { return }
                        self.viewModel.dateWorking.accept(date)
                        }, onCancel: {
                            // write code here
                    })
                }
            })
            .disposed(by: disposeBag)

        repeatTypeButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.showDropDown()
                }
            })
            .disposed(by: disposeBag)
        
        couponButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    self.showCouponVC()
                }
            })
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    if self.checkRequire() {
                        self.showPaymentVC()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupDropDown() {
        self.itemsDropDown.backgroundColor = UIColor.white
        self.itemsDropDown.dimmedBackgroundColor = UIColor.black.withAlphaComponent(0.39)
        self.itemsDropDown.selectionBackgroundColor = UIColor.lightText
        self.itemsDropDown.dataSource = RepeatType.allValues.map { $0.name }
    }
    
    func showDropDown() {
        self.itemsDropDown.anchorView = repeatTypeButton
        self.itemsDropDown.bottomOffset = CGPoint(x: 0, y: repeatTypeButton.height)
        self.itemsDropDown.topOffset = CGPoint(x: 0, y: -repeatTypeButton.height)
        //self.itemsDropDown.offsetFromWindowBottom = CGFloat(200)
        
        // setup custom cell for dropdown
        self.itemsDropDown.customCellConfiguration = { [weak self] (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let self = self else { return }
            cell.backgroundColor = UIColor(hexString: "F9F9F9")
            cell.optionLabel.text = item
            cell.optionLabel.textAlignment = .left
        }
        
        // Action triggered on selection
        self.itemsDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let `self` = self else { return }
            
            //print("Selected item: \(item) at index: \(index)")
            self.itemsDropDown.reloadAllComponents()
            self.viewModel.repeatType.accept(RepeatType(rawValue: index) ?? .none)
        }
        
        self.itemsDropDown.show()
    }
    
    private func bindData() {
        viewModel.packageList.asDriver()
            .drive(onNext: { [weak self] (list) in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.noDataStr.asDriver()
            .drive(onNext: { [weak self] (message) in
                self?.collectionView.showNoResultView(isShow: message.count > 0, title: message, yPosition: 5.0)
            })
            .disposed(by: disposeBag)
        
        viewModel.packageNameStr.asDriver().drive(self.packageNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.packagePriceStr.asDriver().drive(self.packagePriceLabel.rx.text).disposed(by: disposeBag)
        viewModel.addressStr.asDriver().drive(self.addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.hourWorking.asDriver().drive(self.timeLabel.rx.text).disposed(by: disposeBag)
        viewModel.dateWorking.asDriver().map { $0.toFormat("dd MMM yyyy") }.drive(self.dateLabel.rx.text).disposed(by: disposeBag)
        //viewModel.enableConfirm.asDriver().drive(self.confirmButton.rx.isEnabled).disposed(by: disposeBag)
        viewModel.repeatType.asDriver().map{ $0.name }.drive(self.repeatTypeLabel.rx.text).disposed(by: disposeBag)
        viewModel.selectedPackage.asDriver()
            .drive(onNext: { [weak self] (selectedPackage) in
                guard let self = self, let selectedPackage = selectedPackage else { return }
                
                self.viewModel.packageNameStr.accept(selectedPackage.name)
                self.viewModel.packagePriceStr.accept(selectedPackage.price.currencyVN)
                self.timeLabel.text = "\(selectedPackage.timeUsed)s"
                // add item views
                self.itemsStackView.arrangedSubviews.forEach({ (subview) in
                    self.itemsStackView.removeArrangedSubview(subview)
                })
                self.itemsStackView.subviews.forEach({ (subview) in
                    subview.removeFromSuperview()
                })
                selectedPackage.items.forEach { (item) in
                    let itemView = PackageItemView()
                    itemView.setupData(name: item.title)
                    self.itemsStackView.addArrangedSubview(itemView)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper

extension ServicePackageVC {
    
    private func reloadView() {
        
    }
    
    private func checkRequire() -> Bool {
        if viewModel.selectedPackage.value == nil {
            AppMessagesManager.shared.showMessage(messageType: .error, message: "Vui lòng chọn loại dịch vụ!".localized())
            return false
        }
        
        return true
    }
}

// MARK: - UICollectionViewDataSource

extension ServicePackageVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.packageList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PackageCell.cellIdentifier, for: indexPath) as! PackageCell
        cell.viewModel = viewModel.packageList.value[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDataSource

extension ServicePackageVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // reset selection all
        for item in viewModel.packageList.value {
            item.isSelected.accept(false)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.pulsate()
        }
        let cellVM = viewModel.packageList.value[indexPath.row]
        cellVM.isSelected.accept(true)
        viewModel.selectedPackage.accept(cellVM.model)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ServicePackageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if viewModel.packageList.value.count == 0 {
            return CGSize(width: 0, height: 0)
        }
        var cellWidth = (SCREEN_WIDTH - 106.0) / CGFloat(viewModel.packageList.value.count)
        cellWidth = max(cellWidth, 60)
        return CGSize(width: collectionView.height, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 22.0
    }
}

// MARK: - Navigation

extension ServicePackageVC {
    
    func showCouponVC() {
        let addCouponVC = AddCouponVC()
        navigationController?.pushViewController(addCouponVC, animated: true)
    }
    
    func showPaymentVC() {
        let hourWorking: String = self.viewModel.hourWorking.value.count > 0 ? self.viewModel.hourWorking.value : Date().toFormat("HH:mm")
        let params: [String: Any] = ["user_id": PAppManager.shared.currentUser?.id ?? 0,
                                     "address": self.viewModel.address,
                                     "date_working": self.viewModel.dateWorking.value.toFormat("MM/dd/yyyy"),
                                     "hour_working": hourWorking,
                                     "id_promotion": 0,
                                     "location_id": 0,
                                     "lat": self.viewModel.location.coordinate.latitude,
                                     "lng": self.viewModel.location.coordinate.longitude,
                                     "note": self.noteTextView.text!,
                                     "repeat_type": self.viewModel.repeatType.value.rawValue,
                                     "service_id": self.viewModel.serviceModel.id,
                                     "type_bike": self.viewModel.typeBike]
        
        let paymentVC = PaymentVC(params: params)
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}





//
//  ServicePackageVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
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
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var couponLabel: UILabel!
    @IBOutlet weak var couponButton: UIButton!
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteContentLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    // MARK: - Variable
    private let disposeBag = DisposeBag()
    private var viewModel: ServicePackageVM!
    
    init(_ serviceModel: PServiceModel) {
        viewModel = ServicePackageVM(serviceModel)
        
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
    }
    
    private func tapActions() {
        addressButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if let `self` = self {
                    
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
                    self.showPaymentVC()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindData() {
        viewModel.packageList.asDriver()
            .drive(onNext: { [weak self] (list) in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.noDataStr.asDriver()
            .drive(onNext: { [weak self] (message) in
                self?.collectionView.showNoResultView(isShow: message.count > 0, title: message)
            })
            .disposed(by: disposeBag)
        
//        viewModel.successNumberStr.asDriver().drive(self.trueInputLabel.rx.text).disposed(by: disposeBag)
//        viewModel.failNumberStr.asDriver().drive(self.falseInputLabel.rx.text).disposed(by: disposeBag)
//        viewModel.undefinedNumberStr.asDriver().drive(self.undefinedInputLabel.rx.text).disposed(by: disposeBag)
        
        (1...4).forEach { (item) in
            let item = PackageItemView()
            self.itemsStackView.addArrangedSubview(item)
        }
    }
}

// MARK: - Helper

extension ServicePackageVC {
    
    
    private func reloadView() {
        
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
        return CGSize(width: cellWidth, height: collectionView.height)
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
        let paymentVC = PaymentVC()
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}





//
//  PickerImageView.swift
//  LianChat
//
//  Created by Mac on 1/20/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import DKImagePickerController
import Photos
import RxCocoa
import RxSwift
import UIKit

class PickerImageView: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var gridButton: UIButton!
    
    let nibName = "PickerImageView"
    let disposeBag = DisposeBag()
    fileprivate var photoLibrary: PPhotoLibrary!
    fileprivate var numberOfSections = 0
    fileprivate var photos = [UIImage]()
    fileprivate var selectedIndex: Int = -1
    var sendImageBlock: (([UIImage]) -> Void)?
    
    var presentPickerControllerCompletion: (() -> Void)?
    
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
        
        initComponent()
        initData()
    }
    
    private func initComponent() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: PPhotoCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: PPhotoCell.cellIdentifier)
        collectionView.showIndicatorView()
        
        gridButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                guard let `self` = self else { return }
                if let topVC = UIApplication.topVC() {
                    // setup DKImagePicker
                    let pickerController = DKImagePickerController()
                    pickerController.sourceType = .photo
                    //pickerController.UIDelegate = CustomUIDelegate()
                    pickerController.showsCancelButton = true
                    pickerController.maxSelectableCount = 10
                    pickerController.didSelectAssets = { [weak self] (assets: [DKAsset]) in
                        guard let `self` = self else { return }
                        var images = [UIImage]()
                        for asset in assets {
                            asset.fetchOriginalImage(completeBlock: { (image, info) in
                                if let image = image {
                                    images.append(image)
                                }
                            })
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            if images.count > 0 {
                                self.sendImageBlock?(images)
                            }
                        })
                    }
                    topVC.present(pickerController, animated: true, completion: {
                        self.presentPickerControllerCompletion?()
                    })
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func initData() {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            if let `self` = self {
                if result == .authorized {
                    self.photoLibrary = PPhotoLibrary(fetchLimit: 100)
                    self.numberOfSections = 1
                    self.photos = self.photoLibrary.getAllPhotos()
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.collectionView.removeIndicatorView()
                    }
                }
            }
        }
    }
}

extension PickerImageView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.selectedIndex {
            self.selectedIndex = -1
        } else {
            self.selectedIndex = indexPath.row
        }
        collectionView.reloadData()
    }
}

extension PickerImageView: UICollectionViewDataSource {
    
    var sizeForCell: CGSize {
        let frame = collectionView.frame
        return CGSize(width: frame.height, height: frame.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PPhotoCell.cellIdentifier, for: indexPath) as! PPhotoCell
        cell.backgroundColor = UIColor.clear
        cell.imageView.image = photos[indexPath.row]
        if indexPath.row == self.selectedIndex {
            cell.coverView.isHidden = false
            cell.sendButton.isHidden = false
        } else {
            cell.coverView.isHidden = true
            cell.sendButton.isHidden = true
        }
        cell.sendButtonClickBlock = { [weak self] in
            guard let `self` = self else { return }
            self.sendImageBlock?([self.photos[indexPath.row]])
            self.selectedIndex = -1
            collectionView.reloadData()
        }
        
        return cell
    }
}

extension PickerImageView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForCell
    }
}










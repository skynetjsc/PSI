//
//  PSlideShowVC.swift
//  LianChat
//
//  Created by Mac on 1/28/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import AVFoundation
import AVKit
import UIKit

class PSlideShowVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let imageCellIdentifier = "PSlideImageCell"
    var listImages: [Any] = [] // [PImageModel] or [UIImage]
    var listModel: [PSlideImageCellVM] = []
    var currentIndex = 0
    
    init(listImages: [Any], currentIndex: Int = 0) {
        self.listImages = listImages
        self.currentIndex = currentIndex
        for (index, item) in listImages.enumerated() {
            listModel.append(PSlideImageCellVM(model: item, at: IndexPath(row: index, section: 0), currentIndex: currentIndex))
        }
        
        super.init(nibName: "PSlideShowVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if listImages.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.collectionView.scrollToItem(at: NSIndexPath(row: self.currentIndex, section: 0) as IndexPath, at: .centeredHorizontally, animated: false)
            }
        }
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private methods
    
    func initComponent() {
        //CollectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(UINib.init(nibName: imageCellIdentifier, bundle: nil), forCellWithReuseIdentifier: imageCellIdentifier)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(backgroundNotification(notification:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(activeNotification(notification:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
   
    
    @objc func backgroundNotification(notification: Notification) {
        
    }
    
    @objc func activeNotification(notification: Notification) {
        
    }
    
    // MARK: - Action methods
    
    @IBAction func closeButtonClicked(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: UICollectionViewDataSource and UICollectionViewDelegate

extension PSlideShowVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! PSlideImageCell
        cell.viewModel = listModel[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageCell = cell as? PSlideImageCell {
            if let player = imageCell.viewModel?.player {
                player.pause()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if collectionView.visibleCells.count > 0 {
            if let imageCell = collectionView.visibleCells.first as? PSlideImageCell {
                if let player = imageCell.viewModel?.player {
                    //player.play()
                }
            }
        }
    }
    
    // Delegate flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.width
        let height = UIScreen.height
        
        return CGSize.init(width: width, height: height)
    }
}




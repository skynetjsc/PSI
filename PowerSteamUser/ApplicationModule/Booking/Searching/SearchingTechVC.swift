//
//  SearchingTechVC.swift
//  PowerSteamUser
//
//  Created by Mac Mini on 5/21/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import GoogleMaps
import Pulsator
import RxCocoa
import RxSwift
import UIKit

class SearchingTechVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var isFirstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isFirstLoad {
            isFirstLoad = false
            setupPulsator()
        }
    }
}

// MARK: - Initialization

extension SearchingTechVC {
    
    private func initComponent() {
        // write code here
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        //mapView.delegate = self
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 44))
        cancelButton.setTitle("Huỷ".localized(), for: .normal)
        cancelButton.titleLabel?.textColor = UIColor(hexString: "FF1313")
        cancelButton.titleLabel?.font = PDefined.fontMedium(size: 18)
        cancelButton.snp.makeConstraints { (make) in
            make.width.equalTo(64)
        }
        
        navigationBar.setupView(title: "", rightButtons: [cancelButton])
        navigationBar.divView.isHidden = false
        navigationBar.customBackAction = { [weak self] in
            
        }
        cancelButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                
            })
            .disposed(by: disposeBag)
    }
    
    
    private func initData() {
        
    }
    
    func setupPulsator() {
        let pulsator = Pulsator()
        centerButton.layer.addSublayer(pulsator)
        pulsator.numPulse = 5
        pulsator.radius = SCREEN_WIDTH / 2
        pulsator.backgroundColor = PDefined.mainColor.cgColor
        pulsator.start()
    }
    
    func focusToCurrent(toLocation: CLLocation? = nil) {
        if let location = toLocation {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13)
            mapView.animate(to: camera)
        }
    }
}





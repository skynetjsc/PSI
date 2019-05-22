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
    var viewModel: SearchingTechVM!
    var isFirstLoad = true
    
    init(_ bookingID: Int) {
        viewModel = SearchingTechVM(bookingID)
        super.init(nibName: "SearchingTechVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        //mapView.isUserInteractionEnabled = false
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Huỷ".localized(), for: .normal)
        cancelButton.setTitleColor(UIColor(hexString: "FF1313"), for: .normal)
        cancelButton.titleLabel?.font = PDefined.fontMedium(size: 18)
        cancelButton.snp.makeConstraints { (make) in
            make.width.equalTo(64)
            make.height.equalTo(44)
        }
        
        navigationBar.setupView(title: "", rightButtons: [cancelButton])
        navigationBar.divView.isHidden = false
        cancelButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                guard let self = self else { return }
                _ = EZAlertController.alert(PAboutApp.appName, message: "Bạn có chắc muốn huỷ đặt dịch vụ không?", buttons: ["OK", "Huỷ"], tapBlock: { (action, index) in
                    if index == 0 {
                        self.viewModel.cancelBooking(completion: { [weak self] (code, message) in
                            guard let self = self else { return }
                            if code > 0 {
                                self.navigationController?.popViewController(animated:  )
                            } else {
                                AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                            }
                        })
                    }
                })
            })
            .disposed(by: disposeBag)
    }
    
    
    private func initData() {
        
    }
    
    func setupPulsator() {
        let pulsator = Pulsator()
        pulsator.frame.origin = CGPoint(x: centerButton.width / 2, y: centerButton.height / 2)
        centerButton.layer.addSublayer(pulsator)
        pulsator.numPulse = 8
        pulsator.radius = SCREEN_WIDTH / 2 + centerButton.width
        pulsator.animationDuration = 5
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





//
//  HomeVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import GoogleMaps
import RxCocoa
import RxSwift
import UIKit

class HomeVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var bookingView: UIView!
    @IBOutlet weak var bookingButton: UIButton!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: HomeVM!
    fileprivate var sideManager: SideMenuManager!
    var isFirstLoad = true
    var isFoscusCenter = false
    var geocoder: CLGeocoder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        LocationManager.shared.setupLocation()
        LocationManager.shared.updateLocation = { [weak self] (newLocation) in
            guard let `self` = self else { return }
            (self.isFoscusCenter == true) ? nil : self.focusToCurrent(toLocation: newLocation)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false
            configSideMenu()
            //AppMessagesManager.shared.showBookOnWayView()
            //AppMessagesManager.shared.showChooseCarView()
        }
    }
    
}

// MARK: - Initialization

extension HomeVC {
    
    private func initComponent() {
        // write code here
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
        
        viewModel = HomeVM()
        setupNavigationBar()
        configSideMenu()
        tapActions()
    }
    
    private func setupNavigationBar() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        menuButton.snp.makeConstraints { (make) in
            make.width.equalTo(44)
        }
        
        let notificationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        notificationButton.setImage(#imageLiteral(resourceName: "notification-bell"), for: .normal)
        notificationButton.snp.makeConstraints { (make) in
            make.width.equalTo(44)
        }
        
        navigationBar.setupView(title: "", imageIcon: #imageLiteral(resourceName: "logo-navi"), leftButtons: [menuButton], rightButtons: [notificationButton])
        navigationBar.divView.isHidden = false
        
        menuButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                guard let `self` = self else { return }
                // Show left menu
                guard let leftVC = self.sideManager.menuLeftNavigationController else { return }
                self.present(leftVC, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        notificationButton.rx.tap.asDriver()
            .throttle(1)
            .drive(onNext: { [weak self] in
                self?.showCouponList()
            })
            .disposed(by: disposeBag)
    }
    
    func configSideMenu() {
        if sideManager == nil {
            sideManager = SideMenuManager.default
        }
        let menuController = LeftMenuVC()
        let leftNavigationController = UISideMenuNavigationController(rootViewController: menuController)
        sideManager.menuLeftNavigationController = leftNavigationController
        sideManager.menuAddScreenEdgePanGesturesToPresent(toView: self.view, forMenu: .left)
        
        sideManager.menuFadeStatusBar = false
        sideManager.menuPresentMode = .menuSlideIn
        sideManager.menuWidth = round(self.view.width * 0.6)
        sideManager.menuShadowColor = UIColor.black
        sideManager.menuShadowOpacity = 0.5
    }
    
    private func initData() {
        SocketIOManager.shared.establishConnection()
        viewModel.addressStr.asDriver().drive(self.placeLabel.rx.text).disposed(by: disposeBag)
    }
    
    private func tapActions() {
        bookingButton.rx.tap.asDriver()
            .throttle(1.0)
            .drive(onNext: { [weak self] in
                if PAppManager.shared.acceptedAgreement {
                    AppMessagesManager.shared.showChooseCarView(confirmCompletion: { (carName, type) in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                            self?.showServiceList(carName: carName, typeBike: type)
                        })
                    })
                } else {
                    self?.showAgreementVC()
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Helper

extension HomeVC {
    
    /// Refer https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/LocationAwarenessPG/UsingGeocoders/UsingGeocoders.html
    ///
    /// - Parameter location: CLLocation object
    private func geocodeLocation(location: CLLocation) {
        if geocoder == nil {
            geocoder = CLGeocoder()
        }
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let placemarks = placemarks, placemarks.count > 0 {
                //print(placemarks)
                let placemark = placemarks[0]
                var originAddress: String?
                if let addrList = placemark.addressDictionary?["FormattedAddressLines"] as? [String] {
                    originAddress = addrList.joined(separator: ", ")
                }
                self.viewModel.addressStr.accept(originAddress ?? "")
            }
        }
    }
    
    func bookingConfirmHandler() {
        
    }
}

// MARK: - GMSMapViewDelegate

extension HomeVC: GMSMapViewDelegate {
    
    func focusToCurrent(toLocation: CLLocation? = nil) {
        if let location = toLocation {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13)
            mapView.animate(to: camera)
            //viewModel.getAddressFromLatLong(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            geocodeLocation(location: location)
            viewModel.currentLocation = location
        } else if let location = mapView.myLocation {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 13)
            mapView.animate(to: camera)
            //viewModel.getAddressFromLatLong(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            geocodeLocation(location: location)
            viewModel.currentLocation = location
        }
        isFoscusCenter = true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        if isFoscusCenter || (!isFoscusCenter && !LocationManager.shared.isAllowLocationPermission) {
            let latitude = mapView.camera.target.latitude
            let longitude = mapView.camera.target.longitude
            let location = CLLocation(latitude: latitude, longitude: longitude)
            geocodeLocation(location: location)
            viewModel.currentLocation = location
        }
    }
}

// MARK: - Navigation

extension HomeVC {
    
    func showServiceList(carName: String, typeBike: Int) {
        if viewModel.currentLocation != nil {
            //let serviceList = ServiceListVC(viewModel.addressStr.value, viewModel.currentLocation, typeBike)
            //navigationController?.pushViewController(serviceList, animated: true)
            if let tabbarVC = tabBarController as? PTabBarVC {
                tabbarVC.serviceVC.setupData(viewModel.addressStr.value, viewModel.currentLocation, typeBike)
            }
            tabBarController?.selectedIndex = 1
        } else {
            LocationManager.shared.requireLocationAlert()
        }
    }
    
    func showAgreementVC() {
        let agreementVC = AgreementVC()
        navigationController?.pushViewController(agreementVC, animated: true)
    }
    
    func showCouponList() {
        let couponListVC = CouponListVC()
        couponListVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(couponListVC, animated: true)
    }
}





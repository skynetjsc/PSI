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
import SwiftMessages
import UIKit


/// Using general for searching tech view, on the way view, processing view, success view
class SearchingTechVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var summaryLabel: UILabel!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: SearchingTechVM!
    var cancelButton: UIButton!
    var isFirstLoad = true
    
    init(_ bookModel: PBookModel) {
        viewModel = SearchingTechVM(bookModel)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstLoad {
            isFirstLoad = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        cancelButton = UIButton(type: .custom)
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
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                AppMessagesManager.shared.showMessage(messageType: .error, message: message)
                            }
                        })
                    }
                })
            })
            .disposed(by: disposeBag)
        
        navigationBar.customBackAction = { [weak self] in
            guard let self = self else { return }
            SwiftMessages.hideAll()
            AppMessagesManager.shared.bookSuccessSwiftMessage.hide()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    private func initData() {
        cancelButton.isHidden = true
        summaryLabel.isHidden = true
        
        viewModel.getBookingDetail { [weak self] (code, message) in
            guard let self = self else { return }
            if code > 0 {
                switch self.viewModel.bookModel.bookActiveType {
                case .notAssign:
                    self.setupPulsator()
                case .assigned:
                    AppMessagesManager.shared.showBookOnWayView(self.viewModel.bookModel)
                case .doing:
                    AppMessagesManager.shared.showBookProcessingView(self.viewModel.bookModel)
                case .completed:
                    if self.viewModel.bookModel.rating == 0 {
                        AppMessagesManager.shared.showBookSuccessView(self.viewModel.bookModel, confirmCompletion: {
                            self.showBookDetail(self.viewModel.bookModel)
                        })
                    }
                default:
                    break
                }
                self.focusToCurrent(toLocation: CLLocation(latitude: self.viewModel.bookModel.lat, longitude: self.viewModel.bookModel.lng))
            } else {
                self.setupPulsator()
            }
        }
    }
    
    func setupPulsator() {
        cancelButton.isHidden = false
        summaryLabel.isHidden = false
        
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

// MARK: - Navigation

extension SearchingTechVC {
    
    func showBookDetail(_ bookModel: PBookModel) {
        if let navi = self.navigationController {
            let bookDetailVC = BookDetailVC(bookModel.bookingID)
            bookDetailVC.hidesBottomBarWhenPushed = true
            navi.pushViewController(bookDetailVC, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                var viewControllers = [UIViewController]()
                for viewController in navi.viewControllers {
                    if !viewController.isKind(of: SearchingTechVC.self) {
                        viewControllers.append(viewController)
                    }
                }
                navi.viewControllers = viewControllers
            }
        }
    }
}



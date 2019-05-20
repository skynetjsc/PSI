//
//  LocationManager.swift
//  PowerSteamUser
//
//  Created by Mac on 5/19/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps


class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    
    var isAllowLocationPermission: Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        return authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    var updateLocation: ((CLLocation) -> Void)?
}

// MARK: - Location permission
extension LocationManager {
    
    func setupLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        } else {
            requireLocationAlert()
        }
    }
    
    func requireLocation() {
        if !isAllowLocationPermission {
            self.requireLocationAlert()
        }
    }
}

// MARK: - Location delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            updateLocation?(location)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - Helper function
extension LocationManager {
    func requireLocationAlert() {
        let requireAlert = UIAlertController(title: "Địa điểm", message: "Không thể lấy được thông tin vị trí của bạn. Vui lòng bật GPS.", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Cài đặt", style: .default) { (action) in
            if !CLLocationManager.locationServicesEnabled() {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    // If general location settings are disabled then open general location settings
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            } else {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    // If general location settings are enabled then open location settings for the app
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Để sau", style: .cancel, handler: nil)
        requireAlert.addAction(settingAction)
        requireAlert.addAction(cancelAction)
        UIApplication.topVC()?.present(requireAlert, animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

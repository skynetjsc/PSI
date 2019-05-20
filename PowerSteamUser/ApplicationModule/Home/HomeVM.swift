//
//  HomeVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/11/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON
import CoreLocation

class HomeVM {
    
    let disposeBag = DisposeBag()
    var userServices = UserServices()
    let nameStr = BehaviorRelay<String>(value: "")
    let phoneStr = BehaviorRelay<String>(value: "")
    let emailStr = BehaviorRelay<String>(value: "")
    let enableRegister = BehaviorRelay<Bool>(value: false)
    
    var currentLocation: CLLocation!
    var geoLocation: JSON!
    let addressStr = BehaviorRelay<String>(value: "")
    
    init() {
        
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double) {
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(kGoogleMapKey)"
        
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                let responseJson = response.result.value! as! NSDictionary
                if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        self.geoLocation = JSON(results[0])
                        self.addressStr.accept(self.geoLocation["formatted_address"].stringValue)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}




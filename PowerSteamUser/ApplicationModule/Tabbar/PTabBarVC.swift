//
//  PTabBarVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/21/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import CoreLocation

class PTabBarVC: UITabBarController {
    
    var serviceVC: ServiceListVC!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBarItem()
    }
}

// MARK: - Init tabbar

extension PTabBarVC {
    
    private func createTabBarItem() {
        // home
        let homeVC = HomeVC()
        let homeNavi = UINavigationController(rootViewController: homeVC)
        homeNavi.isNavigationBarHidden = true
        let homeType = PTabBarItem.home
        let homeItem = UITabBarItem(title: nil, image: homeType.image, selectedImage: homeType.selectedImage)
        homeItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        homeVC.tabBarItem = homeItem
        
        // service
        serviceVC = ServiceListVC("", CLLocation(latitude: 0, longitude: 0), 1)
        let serviceNavi = UINavigationController(rootViewController: serviceVC)
        serviceNavi.isNavigationBarHidden = true
        let serviceType = PTabBarItem.service
        let serviceItem = UITabBarItem(title: nil, image: serviceType.image, selectedImage: serviceType.selectedImage)
        serviceItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        serviceVC.tabBarItem = serviceItem
        
        // history
        let historyVC = ServiceHistoryVC()
        let historyNavi = UINavigationController(rootViewController: historyVC)
        historyNavi.isNavigationBarHidden = true
        let historyType = PTabBarItem.history
        let historyItem = UITabBarItem(title: nil, image: historyType.image, selectedImage: historyType.selectedImage)
        historyItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        historyVC.tabBarItem = historyItem
        
        // more
        let moreVC = ProfileVC()
        let moreNavi = UINavigationController(rootViewController: moreVC)
        moreNavi.isNavigationBarHidden = true
        let moreType = PTabBarItem.more
        let moreItem = UITabBarItem(title: nil, image: moreType.image, selectedImage: moreType.selectedImage)
        moreItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        moreVC.tabBarItem = moreItem
        
        self.viewControllers = [homeNavi, serviceNavi, historyNavi, moreNavi]
        self.tabBar.isTranslucent = false
        //self.tabBar.tintColor = PDefined.selectedTabbarColor
        self.tabBar.barTintColor = PDefined.backgroudTabbarColor
        self.title = nil
        self.delegate = self
        self.selectedIndex = 0
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -2)
    }
}

// MARK: - UITabBarControllerDelegate

extension PTabBarVC: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
}

// MARK: - Navigation

extension PTabBarVC {
    
}






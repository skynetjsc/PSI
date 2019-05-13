//
//  PackageCellVM.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftDate

class PackageCellVM {
    
    let disposeBag = DisposeBag()
    var model: PPackageModel!
    
    let imageLink = BehaviorRelay<String>(value: "")
    let isSelected = BehaviorRelay<Bool>(value: false)
    
    init(model: PPackageModel) {
        self.model = model
        
    }
}

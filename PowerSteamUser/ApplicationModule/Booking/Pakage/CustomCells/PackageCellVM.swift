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
    var model: PServicePackageModel!
    
    let imageLink = BehaviorRelay<String>(value: "")
    let isSelected = BehaviorRelay<Bool>(value: false)
    
    init(model: PServicePackageModel) {
        self.model = model
        
        imageLink.accept(model.img)
    }
}

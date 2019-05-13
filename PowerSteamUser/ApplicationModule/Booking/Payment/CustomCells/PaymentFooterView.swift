//
//  PaymentFooterView.swift
//  PowerSteamUser
//
//  Created by Mac on 5/13/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class PaymentFooterView: UITableViewHeaderFooterView {

    static let cellIdentifier = "PaymentFooterView"
    
    @IBOutlet weak var addCardButton: UIButton!

    var addCardHandler: (() -> Void)?
    
    @IBAction func addCardDidClick(_ sender: UIButton) {
        self.addCardHandler?()
    }
}

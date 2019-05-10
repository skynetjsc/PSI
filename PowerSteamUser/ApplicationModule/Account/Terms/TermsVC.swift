//
//  TermsVC.swift
//  PowerSteamUser
//
//  Created by Mac on 5/10/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class TermsVC: UIViewController {

    // MARK: - Outlet
    @IBOutlet weak var navigationBar: NavigationView!
    @IBOutlet weak var contentTextView: UITextView!
    
    // MARK: - Variable
    let disposeBag = DisposeBag()
    var viewModel: TermsVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initComponent()
        initData()
    }

}

// MARK: - Initialization

extension TermsVC {
    
    private func initComponent() {
        viewModel = TermsVM()
        //navigationBar.hideLeftButton()
        
    }
    
    
    private func initData() {
        
    }
}




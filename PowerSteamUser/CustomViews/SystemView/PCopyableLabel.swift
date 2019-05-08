//
//  PCopyableLabel.swift
//  LianChat
//
//  Created by Mac on 1/19/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import ActiveLabel
import Foundation

class PCopyableLabel: ActiveLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        sharedInit()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
        
        return false
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu(_:))))
    }
    
    @objc func showMenu(_ sender: Any?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    func enableDetectLink() {
        self.enabledTypes = [.url]
        self.customColor[.url] = UIColor.blue.withAlphaComponent(0.9)
        self.customSelectedColor[.url] = UIColor.blue
        self.handleURLTap { (url) in
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}










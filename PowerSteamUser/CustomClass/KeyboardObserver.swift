//
//  KeyboardObserver.swift
//  WeWorld
//
//  Created by NhatQuang on 1/22/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import UIKit

class KeyboardObserver: NSObject {
	
	static let shared = KeyboardObserver()
	typealias HandleKeyboardAction = (_ isKeyboardShow: Bool, _ keyboardFrame: CGRect) -> Void
	
	private var listAction: [HandleKeyboardAction] = []
	private var isAddObserver = false
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}

// MARK: - Public function

extension KeyboardObserver {
    
	func handleKeyboardState(_ action: @escaping HandleKeyboardAction) {
		self.listAction.append(action)
		isAddObserver ? nil : addObserve()
	}
}

// MARK: - Handle keyboard

extension KeyboardObserver {
    
	private func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardObserver.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardObserver.handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
		isAddObserver = true
	}
	
	@objc func handleKeyboardNotification(notification: Notification) {
		if let userInfo = notification.userInfo {
            let keyboardValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
			let keyboardFrame = keyboardValue?.cgRectValue
            let isKeyboardShow = notification.name == UIResponder.keyboardWillShowNotification
			if let keyboardFrame = keyboardFrame {
				for action in listAction {
					action(isKeyboardShow, keyboardFrame)
				}
			}
		}
	}
}



























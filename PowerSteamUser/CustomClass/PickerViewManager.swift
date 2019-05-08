//
//  PickerViewManager.swift
//  anytime
//
//  Created by NhatQuang on 3/14/18.
//

import Foundation
import UIKit

class PickerView {
	
	typealias SelectedValue = (index: Int, value: String)
	typealias PickerViewResult = (SelectedValue) -> Void
	
	var sourceViewController: UIViewController?
	
	init(sourceViewController: UIViewController?) {
		self.sourceViewController = sourceViewController
	}
}


// MARK: - Custom data

extension PickerView {
    
	func selectIn(listData: [Any], selectedIndex: Int = 0, withTitle title: String, message: String = "", result: PickerViewResult?) {
		guard listData.count > 0 else { return }
		let listStringData = listData.map { String(describing: $0) }
		let pickerView = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
		let pickerViewValues: [[String]] = [listStringData]
		let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndex)
		
		pickerView.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { (viewcontroller, pickerView, index, value) in
			result?((index.row, listStringData[index.row]))
		}
		pickerView.addAction(title: "完了", style: .cancel)
		sourceViewController?.present(pickerView, animated: true, completion: nil)
	}
}

















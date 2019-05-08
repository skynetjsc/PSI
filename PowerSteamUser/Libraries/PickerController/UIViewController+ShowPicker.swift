//
//  UIView+ShowPicker.swift
//  CorrelationPicker
//
//  Created by 王继荣 on 09/11/2016.
//  Copyright © 2016 snowflyer. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showPicker(pickerController: PickerController_Base, completion: (() -> Void)? = nil) {
        pickerController.modalPresentationStyle = .overCurrentContext
        present(pickerController, animated: false, completion: completion)
    }
}

extension UIViewController {
   
    public func showCorrelationPicker(title:String, correlationalJsonStr: String, selectedItems: [String], onDone: ClosureDone? = nil, onCancel: ClosureCancel? = nil) {
        let pickerController = PickerController_Correlation(title: title, correlationalJsonStr: correlationalJsonStr, onDone: onDone, onCancel: onCancel)
        showPicker(pickerController: pickerController) {
            pickerController.setSelected(items: selectedItems)
        }
    }
    
    public func showCorrelationPicker(title:String, correlationalJsonStr: String, selectedIndices: [Int], onDone: ClosureDone? = nil, onCancel: ClosureCancel? = nil) {
        let pickerController = PickerController_Correlation(title: title, correlationalJsonStr: correlationalJsonStr, onDone: onDone, onCancel: onCancel)
        showPicker(pickerController: pickerController) {
            pickerController.setSelected(indices: selectedIndices)
        }
    }
    
    public func showCorrelationPicker(title:String, correlationalJsonFile: String, selectedItems: [String], onDone: ClosureDone? = nil, onCancel: ClosureCancel? = nil) {
        do {
            let correlationalJsonStr = try String(contentsOfFile: correlationalJsonFile)
            showCorrelationPicker(title: title, correlationalJsonStr: correlationalJsonStr, selectedItems: selectedItems, onDone: onDone, onCancel: onCancel)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func showCorrelationPicker(title:String, correlationalJsonFile: String, selectedIndices: [Int], onDone: ClosureDone? = nil, onCancel: ClosureCancel? = nil) {
        do {
            let correlationalJsonStr = try String(contentsOfFile: correlationalJsonFile)
            showCorrelationPicker(title: title, correlationalJsonStr: correlationalJsonStr, selectedIndices: selectedIndices, onDone: onDone, onCancel: onCancel)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func showGroupPicker(title:String, groupData: [[String]], selectedItems: [String], onDone: ClosureDone? = nil, onCancel: ClosureCancel? = nil) {
        let pickerController = PickerController_Group(title: title, groupData: groupData, onDone: onDone, onCancel: onCancel)
        showPicker(pickerController: pickerController) {
            pickerController.setSelected(items: selectedItems)
        }
    }
    
    public func showGroupPicker(title:String, groupData: [[String]], selectedIndices: [Int], onDone: ClosureDone? = nil, onCancel: ClosureCancel? = nil) {
        let pickerController = PickerController_Group(title: title, groupData: groupData, onDone: onDone, onCancel: onCancel)
        showPicker(pickerController: pickerController) {
            pickerController.setSelected(indices: selectedIndices)
        }
    }
    
    public func showDatePicker(title: String, initialDate: Date, minDate: Date? = nil, maxDate: Date? = nil, mode: UIDatePicker.Mode = .dateAndTime, onDone: ClosureDateDone? = nil, onCancel: ClosureCancel? = nil) {
        let pickerController = PickerController_Date(title: title, onDone: onDone, onCancel: onCancel, mode: mode)
        showPicker(pickerController: pickerController) {
            pickerController.setDate(date: initialDate)
            if let date = minDate {
                pickerController.setMinDate(date: date)
            }
            if let date = maxDate {
                pickerController.setMaxDate(date: date)
            }
        }
    }
}

extension UIViewController {
    
    public func showPicker_ChineseRegionalism(title: String, selectedItems: [String], onDone: ClosureDone? = nil, onCancel: ClosureCancel? = nil) {
        if let path = Bundle(for: PickerController_Base.self).path(forResource: "chinese_regionalism", ofType: "json") {
            showCorrelationPicker(title: title, correlationalJsonFile: path, selectedItems: selectedItems, onDone: onDone, onCancel: onCancel)
        }
    }
    
}

//
//  PickerView_Date.swift
//  CorrelationalPicker-Example
//
//  Created by 王继荣 on 10/11/2016.
//  Copyright © 2016 snowflyer. All rights reserved.
//

import UIKit

public typealias ClosureDateDone = (_ date: Date) -> Void

public class PickerControl_Date: PickerControl_Base {

    var onDone: ClosureDateDone?
    
    override var pickerView: UIView {
        return datePicker
    }
    
    var datePicker = UIDatePicker()

    func setDatePickerMode(mode: UIDatePicker.Mode) {
        datePicker.datePickerMode = mode
        datePicker.locale = PDefined.serverRegion.locale
    }
    
    func setDate(date: Date) {
        datePicker.setDate(date, animated: false)
    }
    
    func setMinDate(date: Date) {
        datePicker.minimumDate = date
    }
    
    func setMaxDate(date: Date) {
        datePicker.maximumDate = date
    }
    
    override func didDone() {
        super.didDone()
        onDone?(datePicker.date)
    }
}

//
//  PickerController_Date.swift
//  CorrelationalPicker-Example
//
//  Created by 王继荣 on 10/11/2016.
//  Copyright © 2016 snowflyer. All rights reserved.
//

import UIKit

public class PickerController_Date: PickerController_Base {

    override var pickerControl: PickerControl_Base {
        return _pickerControl
    }
    
    var _pickerControl: PickerControl_Date
    
    public init(title:String, onDone: ClosureDateDone? = nil, onCancel: ClosureCancel? = nil, mode: UIDatePicker.Mode = .dateAndTime) {
        _pickerControl = PickerControl_Date()
        super.init(title: title, onCancel: onCancel)
        setDoneAction(onDone)
        setDatePickerMode(mode: mode)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setDatePickerMode(mode: UIDatePicker.Mode) {
        _pickerControl.setDatePickerMode(mode: mode)
    }
    
    public func setDate(date: Date) {
        _pickerControl.setDate(date: date)
    }
    
    public func setMinDate(date: Date) {
        _pickerControl.setMinDate(date: date)
    }
    
    public func setMaxDate(date: Date) {
        _pickerControl.setMaxDate(date: date)
    }
    
    public func setDoneAction(_ onDone: ClosureDateDone?) {
        _pickerControl.onDone = { [weak self] (date) in
            self?.animateToClose { (finished) in
                if finished {
                    self?.dismiss(animated: false, completion: {
                        onDone?(date)
                    })
                }
            }
        }
    }
}

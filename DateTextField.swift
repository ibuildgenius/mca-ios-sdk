//
//  DateTextField.swift
//  mca-ios-sdk
//
//  Created by mycover Mobile on 23/02/2023.
//

import Foundation
import SwiftUI

struct DatePickerTextField: UIViewRepresentable {
    private let textField = UITextField(frame: .zero)
    private let datePicker = UIDatePicker()
    private let helper = Helper()
    
    public var placeholder: String
    @Binding public var date: Date?
    public var onDateChange: (String) -> Void
    
    func makeUIView(context: Context) -> UITextField {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)
        
        textField.placeholder = placeholder
        textField.inputView = datePicker
        textField.isEnabled = false
        //textField.borderStyle = .roundedRect
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: helper, action: #selector(helper.doneButtonTapped))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        textField.font = UIFont(name: "Metropolis-Regular", size: 14)
        
        
        
        helper.onDateValueChanged = {
            date = datePicker.date
            
            onDateChange(date?.ISO8601Format() ?? "")
        }
        
        helper.onDoneButtonTapped = {
            if date == nil {
                date = datePicker.date
            }
            
            textField.resignFirstResponder()
        }
        
        
        
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let selectedDate = date {
            uiView.text = Globals.dateFormatter.string(from: selectedDate)
        }
        
        uiView.isEnabled = false
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentCompressionResistancePriority(.required, for: .vertical)
         
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Helper {
        public var onDateValueChanged: (() -> Void)?
        public var onDoneButtonTapped: (() -> Void)?
        
        @objc func dateValueChanged() {
            onDateValueChanged?()
        }
        
        @objc func doneButtonTapped() {
            onDoneButtonTapped?()
        }
    }
    
    class Coordinator {}
}

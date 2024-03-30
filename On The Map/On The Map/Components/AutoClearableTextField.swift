//
//  AutoClearableTextField.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import Foundation
import UIKit

class AutoClearableTextField: UITextField {
    var isFirstEdit = true // Tracks whether the text field has been edited
}

class AutoClearableTextFieldDelegate: NSObject, UITextFieldDelegate {
    static let shared = AutoClearableTextFieldDelegate()
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let clearOnceTextField = textField as? AutoClearableTextField else {
            print("Debug: TextField is either not a AutoClearableTextField.")
            return
        }
        guard clearOnceTextField.isFirstEdit else {
            print("Debug: isFirstEdit is false.")
            return
        }
        
        textField.text = "" // Clear text on the first edit
        clearOnceTextField.isFirstEdit = false // Update the flag
    }
}

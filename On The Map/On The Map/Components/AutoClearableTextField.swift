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
    var onTextChanged: ((String?) -> Void)?
    
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Calculate the new text the same way you did before
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Call the closure with the updated text
        onTextChanged?(updatedText)
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Call the closure with nil when the text field is cleared
        onTextChanged?(nil)
        return true
    }
}

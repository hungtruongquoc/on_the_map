//
//  CustomLoginButton.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit

class CustomLoginButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            self.backgroundColor = isEnabled ? .systemBlue : .lightGray
        }
    }
}

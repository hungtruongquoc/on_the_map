//
//  LinkInputViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import UIKit

class LinkInputViewController: UIViewController {

    var onCancel: (() -> Void)?

    @IBOutlet weak var txtLink: AutoClearableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        self.navigationItem.hidesBackButton = true
        txtLink.delegate = AutoClearableTextFieldDelegate.shared
    }

    private func setupCancelButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
    }

    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        cancelButtonTapped()
    }
    
    @objc func cancelButtonTapped() {
        onCancel?()
    }
}

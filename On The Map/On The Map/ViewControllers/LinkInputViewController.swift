//
//  LinkInputViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import UIKit

class LinkInputViewController: UIViewController {

    var onCancel: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        self.navigationItem.hidesBackButton = true
    }

    private func setupCancelButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
    }

    @objc func cancelButtonTapped() {
        onCancel?()
    }
}

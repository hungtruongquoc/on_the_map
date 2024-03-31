//
//  AlertPresentable.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import Foundation
import UIKit
import ObjectiveC

// Declare a global variable to use as a unique key for associated objects
private var ActivityIndicatorContainerKey: UInt8 = 0

protocol AlertPresentable {
    var activityIndicator: UIActivityIndicatorView { get }
    func showAlert(withTitle title: String, message: String)
}

extension AlertPresentable where Self: UIViewController {
    var activityIndicatorContainer: UIView {
        if let container = objc_getAssociatedObject(self, &ActivityIndicatorContainerKey) as? UIView {
            return container
        } else {
            let containerView = UIView(frame: self.view.bounds)
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            let label = UILabel()
            label.text = "Loading..."
            label.textColor = .white
            label.textAlignment = .center
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(activityIndicator)
            containerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                label.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
                label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
            ])
            
            containerView.isHidden = true
            objc_setAssociatedObject(self, &ActivityIndicatorContainerKey, containerView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            return containerView
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert(_ message: String) {
        showAlert(withTitle: "Error", message: message)
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            let container = self.activityIndicatorContainer
            container.isHidden = true
            if let activityIndicator = container.subviews.compactMap({ $0 as? UIActivityIndicatorView }).first {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let container = self.activityIndicatorContainer
            if container.superview == nil {
                self.view.addSubview(container)
            }
            container.isHidden = false
            if let activityIndicator = container.subviews.compactMap({ $0 as? UIActivityIndicatorView }).first {
                activityIndicator.startAnimating()
            }
        }
    }
}

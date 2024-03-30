//
//  LoginViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = CustomLoginButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUsernameTextField()
        setupPasswordTextField()
        setupLoginButton()
        usernameTextField.addTarget(self, action: #selector(usernameTextFieldDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(usernameTextFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameTextField.becomeFirstResponder()
    }
    
    func setupUsernameTextField() {
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.placeholder = "Username"
        usernameTextField.delegate = self
        
        view.addSubview(usernameTextField)
        
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupPasswordTextField() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        view.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        loginButton.isEnabled = false
        
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc func usernameTextFieldDidChange(textField: UITextField) {
        // Check if the text field is empty and update the login button's isEnabled property
        let isUsernameEmpty = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        
        loginButton.isEnabled = !isUsernameEmpty && !isPasswordEmpty
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        // Assuming login validation is successful

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            // Optionally set modalPresentationStyle if you want to cover the entire screen
            mainTabBarController.modalPresentationStyle = .fullScreen
            present(mainTabBarController, animated: true, completion: nil)
        }
    }

}

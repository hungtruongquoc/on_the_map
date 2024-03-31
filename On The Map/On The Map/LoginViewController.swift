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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTextFields()
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
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showLoadingAlert() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func hideLoadingAlert(completion: (() -> Void)? = nil) {
        dismiss(animated: true, completion: completion)
    }
    
    @objc func usernameTextFieldDidChange(textField: UITextField) {
        // Check if the text field is empty and update the login button's isEnabled property
        let isUsernameEmpty = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isPasswordEmpty = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        
        loginButton.isEnabled = !isUsernameEmpty && !isPasswordEmpty
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        Task {
            await performLogin()
        }
    }
    
    func navigateToMainTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController {
            mainTabBarController.modalPresentationStyle = .fullScreen
            present(mainTabBarController, animated: true, completion: nil)
        }
    }
    
    func storeLoginResponse(_ loginResponse: LoginResponse) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.setLoginInfo(loginResponse)
        }
    }
    
    func storeUserResponse(_ user: User) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.setUserInfo(user)
        }
    }


    func performLogin() async {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            showErrorAlert(message: "Username or password is missing.")
            return
        }

        do {
            let loginResponse = try await UdacityNetworkHandler.shared.login(username: username, password: password)
            await MainActor.run {
                navigateToMainTabBarController()
                storeLoginResponse(loginResponse)
            }
            
            let userInfo = try await UdacityNetworkHandler.shared.fetchUserInfo(userId: loginResponse.account.key)
            print("User information: ")
            print(userInfo) // Handle user info as needed
            storeUserResponse(userInfo)
        } catch {
            await MainActor.run {
                showErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func resetTextFields() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        loginButton.isEnabled = false
    }
}

//
//  StudentListViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit

class StudentListViewController: UITableViewController, AlertPresentable {
    // Conforming to the protocol by providing an instance of UIActivityIndicatorView
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    @IBOutlet weak var btnAddNewPin: UIBarButtonItem!
    @IBOutlet weak var btnLogout: LogoutButtonItem!
    
    var shouldReturnToList = false

    private var students: [StudentInformation] = []
    
    @IBAction func startAddNewPin(_ sender: UIBarButtonItem) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            showLocationInputScreen(shouldShowOverwriteConfirmation: appDelegate.currentUserHasPostedLocation, returningToTab: 1)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        StudentFetcher.shared.subscribeToStudentListUpdated { [weak self] studentList, error in
            DispatchQueue.main.async {
                if let error = error {
                    // If there's an error, show an alert or handle the error appropriately
                    self?.showErrorAlert(error.localizedDescription)
                } else {
                    // If there's no error, update the UI with the fetched student list
                    self?.students = studentList
                    self?.tableView.reloadData()
                }
                // Hide the activity indicator after handling the update or error
                self?.hideActivityIndicator()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showActivityIndicator()
        Task {
            await StudentFetcher.shared.fetchStudents()
        }
    }
    
    private func navigateToLoginScreen() {
        // Implementation to navigate back to the login screen
    }
    
    private func setupLogoutButton() {
        btnLogout.onLogoutSuccess = { [weak self] in
            // Handle successful logout, e.g., navigate to the login screen
            print("Logout successful. Navigating to the login screen...")
            self?.navigateToLoginScreen()
        }
    }
    
    // MARK: - Table view data source
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        return students.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)

        // Configure the cell...
        let student = students[indexPath.row]
        cell.textLabel?.text = "\(student.firstName) \(student.lastName), \(student.mapString)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let student = students[indexPath.row]
        openStudentURL(student.mediaURL)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

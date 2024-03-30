//
//  StudentListViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit

class StudentListViewController: UITableViewController {

    @IBOutlet weak var btnAddNewPin: UIBarButtonItem!
    
    var shouldReturnToList = false
    var shouldReloadList = false
    
    var studentFetcher: StudentFetcher?
    
    @IBAction func startAddNewPin(_ sender: UIBarButtonItem) {
        showOverwriteConfirmation(returningToTab: 1)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentFetcher = StudentFetcher(viewController: self)
        shouldReloadList = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check if the list should be reloaded
        if shouldReloadList {
            // Start a new task to call the async method
            Task {
                await studentFetcher?.fetchStudentsAndDisplay()
            }
            shouldReloadList = false
        }
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

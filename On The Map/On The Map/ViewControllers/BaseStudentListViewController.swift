//
//  BaseStudentListViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import UIKit

class BaseStudentListViewController: UIViewController {
    var shouldReturnToList = false
    var shouldReloadList = false
    var studentFetcher: StudentFetcher?

    override func viewDidLoad() {
        super.viewDidLoad()
        studentFetcher = StudentFetcher(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check if the list should be reloaded
        if shouldReloadList {
            studentFetcher?.fetchStudentsAndDisplay()
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

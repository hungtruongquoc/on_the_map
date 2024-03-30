//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit

class StudentMapViewController: UIViewController {

    @IBOutlet weak var btnAddNewPin: UIBarButtonItem!
    
    var shouldReturnToList = false
    
    @IBAction func startAddNewPin(_ sender: UIBarButtonItem) {
        showOverwriteConfirmation(returningToTab: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

//
//  LocationInputViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit

class LocationInputViewController: UIViewController {
    
    var onCancel: (() -> Void)?
    
    @IBOutlet weak var txtLocation: AutoClearableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtLocation.delegate = AutoClearableTextFieldDelegate.shared
        initializeStudentInfoForForm()
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        onCancel?()
    }
    
    func initializeStudentInfoForForm() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.initializeNewStudentInfo()
        // Now, appDelegate.newStudentInfo is a new instance and can be used to collect form data
    }
    
    // Assuming you've connected a segue from this view controller to LinkInputViewController in the storyboard
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToLinkInputSegue", // Use the actual segue identifier you've set in the storyboard
           let linkInputVC = segue.destination as? LinkInputViewController {
            // Pass the onCancel closure to the LinkInputViewController
            linkInputVC.onCancel = self.onCancel
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

//
//  LocationInputViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit

class LocationInputViewController: UIViewController {
    
    var onCancel: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        onCancel?()
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

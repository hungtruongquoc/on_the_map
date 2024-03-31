//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit
import MapKit

class StudentMapViewController: BaseStudentListViewController,MKMapViewDelegate {

    @IBOutlet weak var mapStudent: MKMapView!
    @IBOutlet weak var btnAddNewPin: UIBarButtonItem!
    
    @IBAction func startAddNewPin(_ sender: UIBarButtonItem) {
        showOverwriteConfirmation(returningToTab: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldReloadList = true
        mapStudent.delegate = self
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

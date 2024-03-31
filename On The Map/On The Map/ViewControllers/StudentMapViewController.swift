//
//  StudentMapViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/29/24.
//

import UIKit
import MapKit

class StudentMapViewController: BaseStudentListViewController, MKMapViewDelegate {
    @IBOutlet weak var mapStudent: MKMapView!
    @IBOutlet weak var btnAddNewPin: UIBarButtonItem!
    @IBOutlet weak var btnLogout: LogoutButtonItem!
    
    @IBAction func startAddNewPin(_ sender: UIBarButtonItem) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            showLocationInputScreen(shouldShowOverwriteConfirmation: appDelegate.currentUserHasPostedLocation, returningToTab: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapStudent.delegate = self
        
        // Subscribe to student list updates using the shared StudentFetcher instance
        StudentFetcher.shared.subscribeToStudentListUpdated { [weak self] studentList, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Handle the error, for example, by showing an alert
                    self?.showErrorAlert(error.localizedDescription)
                } else {
                    // If there's no error, proceed to update the map annotations with the student list
                    self?.updateMapAnnotations(with: studentList)
                }
                self?.hideActivityIndicator()
            }
        }
    }
    
    private func updateMapAnnotations(with students: [StudentInformation]) {
        var annotations = [MKPointAnnotation]()

        for student in students {
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)

            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL

            // Here we create the annotation and set its coordinate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }

        // When the array is complete, we add the annotations to the map.
        mapStudent.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? MKPointAnnotation {
            let identifier = "studentPin"
            var view: MKMarkerAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                let infoButton = UIButton(type: .detailDisclosure)
                view.rightCalloutAccessoryView = infoButton
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? MKPointAnnotation, control == view.rightCalloutAccessoryView {
            // Handle the tap event on the callout accessory
            // Open the media URL or do something else
            if let url = URL(string: annotation.subtitle ?? ""), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Handle the error, invalid URL case
            }
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

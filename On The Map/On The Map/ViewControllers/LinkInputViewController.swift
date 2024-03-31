//
//  LinkInputViewController.swift
//  On The Map
//
//  Created by Hung Truong on 3/30/24.
//

import UIKit
import MapKit
import CoreLocation

class LinkInputViewController: UIViewController, MKMapViewDelegate {
    let geocoder = CLGeocoder()
    var onCancel: (() -> Void)?
    private var cityStateInfo: String?
    private var latitude: Double?
    private var longitude: Double?

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var mapCityState: MKMapView!
    
    @IBOutlet weak var txtLink: AutoClearableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        btnSubmit.isEnabled = false
        
        self.navigationItem.hidesBackButton = true
        txtLink.delegate = AutoClearableTextFieldDelegate.shared
        mapCityState.delegate = self
        
        // Set up the closure to enable/disable the button
        AutoClearableTextFieldDelegate.shared.onTextChanged = { [weak self] text in
            // Check if the text is a valid URL
            if let urlString = text, let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                self?.btnSubmit.isEnabled = true
            } else {
                self?.btnSubmit.isEnabled = false
            }
        }
    }

    private func setupCancelButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
    }
    
    private func getGeocodeLocation(cityState: String) {
        geocoder.geocodeAddressString(cityState) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    // Geocoding failed with an error
                    self?.showAlert(withTitle: "Location Error", message: "Failed to find the location: \(error.localizedDescription)")
                } else if let placemark = placemarks?.first, let location = placemark.location {
                    // Geocoding succeeded, update the map with the location
                    self?.updateMapToLocation(location)
                } else {
                    // Geocoding did not fail but no location was found
                    self?.showAlert(withTitle: "Location Not Found", message: "Could not find the specified location. Please try again.")
                }
            }
        }
    }
    
    private func updateMapToLocation(_ location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapCityState.setRegion(coordinateRegion, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        mapCityState.addAnnotation(annotation)
        
        // Save the latitude and longitude
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }
    
    private func postStudentLocation() async {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let newStudentInfo = appDelegate.getUserInfo() else {
            return
        }
        
        guard let cityState = cityStateInfo, let lat = latitude, let lon = longitude else {
            showAlert(withTitle: "Missing Information", message: "The location information is incomplete. Please make sure you have entered a valid city and state.")
            return
        }

        // Ensure we have all the required information
        guard let link = txtLink.text, let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
            showAlert(withTitle: "Invalid URL", message: "The URL you entered is not valid. Please enter a valid URL.")
            // Show an error to the user or disable the submit button
            return
        }

        // Create a StudentLocationRequest object
        let studentLocationRequest = StudentLocationRequest(uniqueKey: newStudentInfo.key,
                                                            firstName: newStudentInfo.firstName,
                                                            lastName: newStudentInfo.lastName,
                                                            mapString: cityState,
                                                            mediaURL: link,
                                                            latitude: lat,
                                                            longitude: lon)

        // Post the location using the StudentNetworkHandler
        Task {
            do {
                let response = try await StudentNetworkHandler.shared.postStudentLocation(studentLocation: studentLocationRequest)
                // Handle the successful response, maybe show confirmation to the user
                print("Student Location Posted: \(response)")
                cancelButtonTapped()
                StudentFetcher.shared.forceRefreshStudentList()
            } catch {
                // Handle the error by showing an alert or something similar to the user
                print("Failed to Post Student Location: \(error)")
            }
        }
    }

    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        Task {
            await postStudentLocation()
        }
    }
    
    @objc func cancelButtonTapped() {
        onCancel?()
    }
    
    func setCityStateInfo(_ info: String?) {
        cityStateInfo = info
        guard let cityState = cityStateInfo, !cityState.isEmpty else { return }
        getGeocodeLocation(cityState: cityState)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            annotationView.annotation = annotation
            return annotationView
        } else {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
    }
}

//
//  DetailViewController.swift
//  Snacktacular
//
//  Created by Mia Tortolani on 11/26/17.
//  Copyright © 2017 Mia Tortolani. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class DetailViewController: UIViewController {
    
    // MARK: - Outlets and Variables
    @IBOutlet weak var placeNameField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var placeData: PlaceData?
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    let regionRadius = 1000.00
    
    // MARK: - Functions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        if let placeData = placeData {
            updateUserInterface()
            centerMap(mapLocation: placeData.coordinate, regionRadius: regionRadius)
            mapView.addAnnotation(placeData)
            mapView.selectAnnotation(placeData, animated: true)
        } else {
            placeData = PlaceData(placeName: "", address: "", coordinate: CLLocationCoordinate2D(), postingUserID: "")
            getLocation()
        }
        
        placeNameField.becomeFirstResponder()
    }
    
    func updateUserInterface() {
        placeNameField.text = placeData!.placeName
        addressField.text = placeData!.address
    }
    
    func centerMap(mapLocation: CLLocationCoordinate2D, regionRadius: CLLocationDistance) {
        let region = MKCoordinateRegionMakeWithDistance(mapLocation, regionRadius, regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        placeData?.placeName = placeNameField.text!
        placeData?.address = addressField.text!
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func lookUpButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentInAddMode = presentingViewController is UINavigationController
        if isPresentInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK: - Extensions

extension DetailViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func handleLocationAuthoriationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Please go into 'Settings' and enable location services for this app.")
        case .restricted:
            showAlertToPrivacySettings(title: "Location services denied", message: "It may be that parental controls are restricing location use in this app.")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplicationOpenSettingsURLString) else {print("Something went wrong here!"); return}
        let settingsAction = UIAlertAction(title: "OK", style: .default) {value in UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)}
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationAuthoriationStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        currentLocation = locations.last
        let currentLatitude = currentLocation.coordinate.latitude
        let currentLongitude = currentLocation.coordinate.longitude
        geoCoder.reverseGeocodeLocation(currentLocation, completionHandler:
            {placemarks, error in
                if placemarks != nil {
                    let placemark = placemarks?.last
                    self.placeData?.placeName = (placemark?.name)!
                    self.placeData?.address = (placemark?.thoroughfare)!
                    self.placeData?.coordinate = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
                    self.centerMap(mapLocation: (self.placeData?.coordinate)!, regionRadius: self.regionRadius)
                    self.mapView.addAnnotation(self.placeData!)
                    self.mapView.selectAnnotation(self.placeData!, animated: true)
                    self.updateUserInterface()
                } else {
                    print("Error retrieving place.")
                }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location")
    }
        
    }

extension DetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "Marker"
        var view: MKPinAnnotationView
        if let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            dequedView.annotation = annotation
            view = dequedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .custom)
        }
        return view
    }
}

//
//  ViewController.swift
//  AugmentedReality
//
//  Created by Aneena on 14/12/17.
//  Copyright © 2017 Aneena. All rights reserved.
//

import UIKit

import CoreLocation
import MapKit

class ViewController: UIViewController {
    
    fileprivate var places = [Place]()
    fileprivate let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tapARButton: UIButton!

    var arViewController: ARViewController!
    var startedLoadingPOIs = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tapARButton.layer.borderWidth = 1
        self.tapARButton.layer.borderColor = UIColor.clear.cgColor
        self.tapARButton.layer.cornerRadius = 12

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showARController(_ sender: Any) {
        arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 30
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        arViewController.setAnnotations(places)
        arViewController.uiOptions.debugEnabled = false
        arViewController.uiOptions.closeButtonEnabled = true
        
        self.present(arViewController, animated: true, completion: nil)
    }
    
    func showInfoView(forPlace place: Place) {
        if (UIApplication.shared.canOpenURL(NSURL(string:"comgooglemaps://")! as URL)) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?saddr=&daddr=\(place.location!.coordinate.latitude),\(place.location!.coordinate.longitude)&directionsmode=driving")!, options: [:]) { (completed:Bool) in
                    print("Opened googlemaps")
            }
            
        } else {
            print("Can't use comgooglemaps://");
            UIApplication.shared.open(URL(string:
                "https://maps.google.com/?q=@\(place.location!.coordinate.latitude),\(place.location!.coordinate.longitude)")!, options: [:]) { (completed:Bool) in
                    print("Opened googlemaps")
            }
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            let location = locations.last!
            if location.horizontalAccuracy < 100 {
                manager.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.region = region
                
                if !startedLoadingPOIs {
                    startedLoadingPOIs = true
                    let loader = PlacesLoader()
                    loader.loadPOIS(location: location, radius: 1000) { placesDict, error in
                        if let dict = placesDict {
                            guard let placesArray = dict.object(forKey: "results") as? [NSDictionary]  else { return }
                            
                            for placeDict in placesArray {
                                let latitude = placeDict.value(forKeyPath: "geometry.location.lat") as! CLLocationDegrees
                                let longitude = placeDict.value(forKeyPath: "geometry.location.lng") as! CLLocationDegrees
                                let reference = placeDict.object(forKey: "reference") as! String
                                let name = placeDict.object(forKey: "name") as! String
                                let address = placeDict.object(forKey: "vicinity") as! String
                                
                                let location = CLLocation(latitude: latitude, longitude: longitude)
                                let place = Place(location: location, reference: reference, name: name, address: address)
                                
                                self.places.append(place)
                                let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.placeName)
                                DispatchQueue.main.async {
                                    self.mapView.addAnnotation(annotation)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension ViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        return annotationView
    }
}

extension ViewController: AnnotationViewDelegate {
    @objc func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation as? Place {
            print(places[0])
            print("annotation",annotation)
            self.showInfoView(forPlace: annotation)
        }
    }
}



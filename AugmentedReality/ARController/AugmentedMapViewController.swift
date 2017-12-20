//
//  AugmentedMapViewController.swift
//  Sabarimala
//
//  Created by Aneena on 11/11/17.
//  Copyright © 2017 Experion Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import CoreLocation

class AugmentedMapViewController: UIViewController,GMSMapViewDelegate {
    @IBOutlet var parkingSpace_MapView: GMSMapView!
    fileprivate let locationManager = CLLocationManager()
    var currentlat = CLLocationDegrees()
    var currentlong = CLLocationDegrees()
    var currentLocation:CLLocationCoordinate2D?
    var destinationLocation : CLLocationCoordinate2D?
    var coordinatecurrent = CLLocation()
    var coordinateDest = CLLocation()
    var destinationlat:Double? = nil
    var destinationlong:Double? = nil
     var arLat = CLLocationDegrees()
    var arLong = CLLocationDegrees()
    var destName = String()
//     var directionURLFromAR = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "AR View"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMap(){
        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?alternatives=true&destination=\(coordinateDest.coordinate.latitude),\( coordinateDest.coordinate.longitude)&key=AIzaSyA2d36xsi3-TsVJ2Zn8s3ZEHiDLBhbSj4g&mode=driving&origin=\(coordinatecurrent.coordinate.latitude),\( coordinatecurrent.coordinate.longitude)"
        print("inside",directionURL)
        Alamofire.request(directionURL).responseJSON
            { response in
                
                if let JSON = response.result.value {
                    
                    let mapResponse: [String: AnyObject] = JSON as! [String : AnyObject]
                    
                    let routesArray = (mapResponse["routes"] as? Array) ?? []
                    var index = 0 ;
                    // let routes = (routesArray.first as? Dictionary<String, AnyObject>) ?? [:]
                    for routes in (mapResponse["routes"] as! [[String:AnyObject]]){
                        let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                        let polypoints = (overviewPolyline["points"] as? String) ?? ""
                        let line  = polypoints
                        index = index + 1;
                        self.addPolyLine(encodedString: line,index: index)
                    }
                    
                }
        }

    }
    func addPolyLine(encodedString: String,index:Int) {
        
        let path = GMSMutablePath(fromEncodedPath: encodedString)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        if(index%2==0){
            polyline.strokeColor = .blue
        }else{
            polyline.strokeColor = .red
        }
        self.parkingSpace_MapView.isHidden = false
        polyline.map = self.parkingSpace_MapView
    }
}
extension AugmentedMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .denied || status == .restricted {
            let alertController = UIAlertController(title:AugmentedReality.Title.rawValue,message:AugmentedReality.Message.rawValue, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title:AugmentedReality.Cancel.rawValue, style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title:AugmentedReality.Settings.rawValue, style: .default) { (UIAlertAction) in
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
    // MapView.isMyLocationEnabled = true
    currentLocation = CLLocationCoordinate2D(latitude:CLLocationDegrees(locations[0].coordinate.latitude), longitude:CLLocationDegrees(locations[0].coordinate.longitude))
    self.parkingSpace_MapView.camera = GMSCameraPosition.camera(withTarget: currentLocation!,zoom: 8.5, bearing: 2.0, viewingAngle: 9.0)
    let path = GMSMutablePath()
    let markerStart:GMSMarker = GMSMarker.init(position: self.currentLocation!)
    self.currentlat = locations[0].coordinate.latitude
    self.currentlong = locations[0].coordinate.longitude
    coordinatecurrent = CLLocation(latitude: currentlat, longitude: currentlong)
    print("coordinatecurrent",coordinatecurrent)

    markerStart.icon = GMSMarker.markerImage(with: UIColor.red)
    markerStart.title = "My Location"
    markerStart.map = self.parkingSpace_MapView
    path.add(markerStart.position)
    print("arLat",arLat)
    print("arLong",arLong)

    coordinateDest = CLLocation(latitude:arLat, longitude: arLong)
    destinationLocation = CLLocationCoordinate2D(latitude:arLat, longitude:arLong)
    print("destinationLocation",destinationLocation)
    let markerDest:GMSMarker = GMSMarker.init(position: destinationLocation!)
    
    markerDest.icon = GMSMarker.markerImage(with: UIColor.green)
    markerDest.map = self.parkingSpace_MapView
    markerDest.title = self.destName
    path.add(markerDest.position)
    self.showMap()
    let bounds = GMSCoordinateBounds(path: path)
    self.parkingSpace_MapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
    
    
}
}

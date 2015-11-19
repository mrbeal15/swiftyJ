//
//  ViewController.swift
//  SwiftyJ
//
//  Created by Apprentice on 11/18/15.
//  Copyright © 2015 Apprentice. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreLocation
import MapKit

class CustomPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        
        let url = "http://localhost:3000/names"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    for (_, location):(String, JSON) in json {
                        print(location)
                        let name = location["name"].stringValue, lat = Float(location["lat"].stringValue), lng = Float(location["lng"].stringValue)
                        let pin = CustomPin(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat!), longitude: CLLocationDegrees(lng!)), title: name, subtitle: "Where you at")
                        self.mapView.addAnnotation(pin)
                        self.mapView.centerCoordinate = pin.coordinate
                    }
                    //                    print("JSON: \(json)")
                }
                
            case .Failure(let error):
                print(error)
            }
        }
        
//        let pin = CustomPin(coordinate: CLLocationCoordinate2D(latitude: 41.8897166, longitude: -87.6376107), title: "Lorena", subtitle: "Where you at")
//        let pin1 = CustomPin(coordinate: CLLocationCoordinate2D(latitude: 41.8897167, longitude: -87.6376105), title: "Niki", subtitle: "Where you at")
//        let pin2 = CustomPin(coordinate: CLLocationCoordinate2D(latitude: 41.8897165, longitude: -88.8), title: "Matt", subtitle: "Where you at")
//        let pin3 = CustomPin(coordinate: CLLocationCoordinate2D(latitude: 41.8897164, longitude: -85.8), title: "Eileen", subtitle: "Where you at")
//        
//        //method that parses the JSON into new pin objects
//        //let pin = Pin
//        mapView.centerCoordinate = pin.coordinate
//        mapView.addAnnotation(pin)
//        
//        mapView.centerCoordinate = pin1.coordinate
//        mapView.addAnnotation(pin1)
//
//        mapView.centerCoordinate = pin2.coordinate
//        mapView.addAnnotation(pin2)
//
//        mapView.centerCoordinate = pin3.coordinate
//        mapView.addAnnotation(pin3)

        
//        Alamofire.request(.POST, "http://localhost:3000/names", parameters: ["coord": "\(location!.coordinate)"])
        Alamofire.request(.POST, "http://localhost:3000/names", parameters: ["coord": ["lat":"\(location!.coordinate.latitude)", "lng":"\(location!.coordinate.longitude)"]])
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Errors: " + error.localizedDescription )
    }
    
    func locationmanager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if case .AuthorizedWhenInUse = status {
            manager.requestLocation()
        }
    }
    
  

    @IBAction func nameTextField(name: UITextField) {

        Alamofire.request(.POST, "http://localhost:3000/names", parameters: ["name": "\(name.text!)"], encoding: .JSON)
        //After we send name we should set field back to default "name"
    }
    
}


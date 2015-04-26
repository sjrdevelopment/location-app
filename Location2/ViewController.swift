//
//  ViewController.swift
//  Location2
//
//  Created by Stuart Robinson on 26/04/2015.
//  Copyright (c) 2015 SJR Development. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("loaded ok")
 
        // location function stuff
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func getMyLocation(sender: AnyObject) {
        println("getting location");
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("updated location")
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
       
            }
            
            if (placemarks.count > 0) {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        println("got new placemark")
        //stop updating location to save battery life
        self.locationManager.stopUpdatingLocation()
        println("Latitude: \(placemark.location.coordinate.latitude)")
        println("Longitude: \(placemark.location.coordinate.longitude)")
        println("Locality: \(placemark.locality)")
        /*
        println("Locality: \(placemark.locality)")
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
        */
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("failed to update location \(error.localizedDescription)");
    }


}


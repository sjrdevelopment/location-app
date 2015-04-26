//
//  ViewController.swift
//  Location2
//
//  Created by Stuart Robinson on 26/04/2015.
//  Copyright (c) 2015 SJR Development. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        var oldX = 0
        var oldY = 0
        var oldZ = 0
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("loaded ok")
 
        // accelerometer stuff
        if motionManager.accelerometerAvailable {
            
            
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [weak self] (data: CMAccelerometerData!, error: NSError!) in
                
                var newX = Int(data.acceleration.x * 10)
                var newY = Int(data.acceleration.y * 10)
                var newZ = Int(data.acceleration.z * 10)
                
               
                if( newX != oldX || newY != oldY || newZ != oldZ) {
                  
                    oldX = newX
                    oldY = newY
                    oldZ = newZ
                    
                    println("X: \(newX)")
                    println("Y: \(newY)")
                    println("Z: \(newZ)")
        
                }

            }
        }
       
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


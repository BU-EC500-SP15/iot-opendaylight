//
//  AppDelegate.swift
//  Compass
//
//  Created by Mark on 2/22/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, ESTIndoorLocationManagerDelegate {
    var window: UIWindow?

    /* CLLocation Managing */
    var locationManager: CLLocationManager! = nil
    var isExecutingInBackground = false
    
    /* Estimote IndoorLocation */
    var location: ESTLocation?
    var indoorCoords: String!
    private var manager: ESTIndoorLocationManager!
    
    var didJustStartApplication = true
    var didUpdateIndoorLocation = false
    var updateIndoorLocationTimer: NSTimer?
    var notIndoorLocationTimer: NSTimer?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        println("Device Name:  " + UIDevice.currentDevice().name)
        println("Device Model:  " + UIDevice.currentDevice().model)
        println("System Version:  " + UIDevice.currentDevice().systemVersion)
        println("Device ID:  " + UIDevice.currentDevice().identifierForVendor.UUIDString)
        println("\n-------------------------------\n")
        
        // initialize parse sdk
        Parse.setApplicationId("RWNddnNuYwk6BfS87tsIlSXNPX1FIHOsDxYriBId",
            clientKey: "jZtdpdn7ydTL3izCvenqQchVGG5Ctv8ApaLzeq8E")
        
        // init indoor manager
        self.initIndoorLocationManaging()
        
        // init location manager
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        if (self.locationManager.respondsToSelector("requestAlwaysAuthorization")) {
            self.locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingLocation()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
        isExecutingInBackground = true
        
        /* Reduce the accuracy to ease the strain on iOS while in background */
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func applicationWillEnterForeground(application: UIApplication) {
        isExecutingInBackground = false
        
        /* increase location detection accuracy in foreground */
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }

    // MARK: Location Manager Delegate Methods
    
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        if isExecutingInBackground {
            // in background - do not do any heavy processing
        } else {
            // in foreground - resume normal processing
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var newLocation: CLLocation = locations.last as! CLLocation
        
        var lat = newLocation.coordinate.latitude
        var long = newLocation.coordinate.longitude
        var coords = String(format: "%f,%f", lat,long)
        
        // put 1 in LocGPS accuracy flag
        MBSwiftPostman().getFlagEnableForLocGPS()
        
        // post content instance with updated GPS position
        MBSwiftPostman().createLocGPSContentInstance(coords)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Location manager failed with error: \(error)")
        
        // put 0 in LocGPS accuracy flag
        MBSwiftPostman().getFlagDisableForLocGPS()
    }
        
    // MARK: ESTIndoorLocationManager delegate
    
    func indoorLocationManager(manager: ESTIndoorLocationManager!, didUpdatePosition position: ESTOrientedPoint!, inLocation location: ESTLocation!) {
        
        var yourPos = NSString(format: "Your position in %@ ---> x: %.2f   y: %.2f",
            location.name,
            position.x,
            position.y) as String
        
        self.indoorCoords = String(format: "%@,%.2f,%.2f", location.name, position.x, position.y)
        println(self.indoorCoords)
        
        if !self.didUpdateIndoorLocation {
            
            // stop not indoor timer
            self.notIndoorLocationTimer?.invalidate()
            
            // init update timer
            self.updateIndoorLocationTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateUserIndoorLocation", userInfo: nil, repeats: true)
            
            self.didUpdateIndoorLocation = true
        }
    }
    
    func indoorLocationManager(manager: ESTIndoorLocationManager!, didFailToUpdatePositionWithError error: NSError!) {
        
        if self.didUpdateIndoorLocation || self.didJustStartApplication {
            
            NSLog(error.localizedDescription)
            
            // stop update indoor location timer
            self.updateIndoorLocationTimer?.invalidate()
            
            // init not indoor location timer
            self.notIndoorLocationTimer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "updateUserNotIndoorLocation", userInfo: nil, repeats: true)
            
            self.didUpdateIndoorLocation = false
            self.didJustStartApplication = false
        }
    }
    
    func loadLocationFromJSON() {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("location", ofType: "json")
        let content = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil) as! String
        
        let indoorLocation = ESTLocationBuilder.parseFromJSON(content)
        self.location = indoorLocation
    }
    
    func initIndoorLocationManaging() {
        
        self.loadLocationFromJSON()
        
        // init indoor manager
        self.manager = ESTIndoorLocationManager()
        self.manager.delegate = self
        
        // start indoor locating
        self.manager.startIndoorLocation(self.location)
    }
    
    func updateUserIndoorLocation() {
        
        // put 1 in LocBeacon accuracy flag
        MBSwiftPostman().getFlagEnableForLocBeacon()
        
        // post content instance with updated indoor position
        MBSwiftPostman().createLocBeaconContentInstance(self.indoorCoords)
    }
    
    func updateUserNotIndoorLocation() {
        
        // put 0 in LocBeacon accuracy flag
        MBSwiftPostman().getFlagDisableForLocBeacon()
    }
}


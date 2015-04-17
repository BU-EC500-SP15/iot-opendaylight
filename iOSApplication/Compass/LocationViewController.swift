//
//  LocationViewController.swift
//  Compass
//
//  Created by Mark on 3/31/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UISearchBarDelegate, ESTIndoorLocationManagerDelegate {
    
    @IBOutlet var indoorSearchBar: UISearchBar!
    @IBOutlet var indoorLocationView: ESTIndoorLocationView!
    @IBOutlet var showTraceSwitch: UISwitch!
    @IBOutlet var positionLabel: UILabel!
    
    var location: ESTLocation?
    private var manager: ESTIndoorLocationManager!
    
    var queriedUserView = UIImageView?()
    
    /* Searching */
    var isMappingQueriedUser: Bool = false
    var updatingLocationTimer: NSTimer?
    
    var accuracyFlag = ""
    var queriedUser = ""
    var queriedUserUUID = ""
    var queriedUserAnnotation: MBUserLocGPSAnnotation?
    
    var queriedUserBeaconCoordinates = ""
    var queriedUserGPSCoordinates = CLLocationCoordinate2DMake(0, 0)
    
    let colors = [
        48808: UIColor(red: 84/255, green: 77/255, blue: 160/255, alpha: 1),
        10869: UIColor(red: 142/255, green: 212/255, blue: 220/255, alpha: 1),
        32129: UIColor(red: 162/255, green: 213/255, blue: 181/255, alpha: 1)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indoorSearchBar.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadLocationFromJSON()
        
        // init indoor manager
        self.manager = ESTIndoorLocationManager()
        self.manager.delegate = self
        
        // start drawing location
        self.indoorLocationView.drawLocation(self.location)
        self.manager.startIndoorLocation(self.location)
        
        // disable rotation
        self.indoorLocationView.rotateOnPositionUpdate = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.manager.stopIndoorLocation()
    }
    
    func loadLocationFromJSON() {
        let bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("location", ofType: "json")
        let content = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil) as! String
        
        let indoorLocation = ESTLocationBuilder.parseFromJSON(content)
        
        self.location = indoorLocation
        self.title = indoorLocation.name
    }
    
    func drawQueriedUserIndoorLocation() {
        
    }
    
    // MARK: UISwitch events
    
    @IBAction func showTraceSwitchChanged() {
        self.indoorLocationView.clearTrace()
        self.indoorLocationView.traceColor = UIColor.blueColor()
        self.indoorLocationView.showTrace = self.showTraceSwitch.on
    }
    
    // MARK: ESTIndoorLocationManager delegate
    
    func indoorLocationManager(manager: ESTIndoorLocationManager!, didUpdatePosition position: ESTOrientedPoint!, inLocation location: ESTLocation!) {
        
        // user's position inside room
        self.positionLabel.text = NSString(format: "x: %.2f   y: %.2f    α: %.2f",
            position.x,
            position.y,
            position.orientation) as String
        
        // keep updating user location
        self.indoorLocationView.updatePosition(position)
    }
    
    func indoorLocationManager(manager: ESTIndoorLocationManager!, didFailToUpdatePositionWithError error: NSError!) {
        
        self.positionLabel.text = "It seems that you are outside the location."
    }
    
    // MARK: Search Bar Delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.indoorSearchBar.resignFirstResponder()
        
        var searchText = self.indoorSearchBar.text
        var trimmedSearchText = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if ((searchText == "") || (trimmedSearchText == "")) {
            self.displayAlert("Error", error: "Please enter a valid username.")
        } else {
            
            // clear queried user marker if any
            if isMappingQueriedUser {

                self.isMappingQueriedUser = false
                
                // stop updating user location timer
                self.updatingLocationTimer?.invalidate()
            }
            
            // clear cached user query info
            self.queriedUser = ""
            self.queriedUserUUID = ""
            self.accuracyFlag = ""
            
            println("Searching for: \(searchText)...")
            self.getQueriedUserUUID(searchText)
            
            // init update queried user location timer
            self.updatingLocationTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateQueriedUserLocation", userInfo: nil, repeats: true)
        }
    }
    
    func updateQueriedUserLocation() {
        println("Getting \(self.queriedUser)'s location again...")
        self.getQueriedUserUUID(self.queriedUser)
    }
    
    // MARK: Query Location Handling
    
    func getQueriedUserUUID(userid: String) {
        
        let httpMethod = "GET"
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkUserAE/"+userid+"/?from=http:52.10.62.166:10000&requestIdentifier=12345&resultContent=2"
        
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        
        let queue = NSOperationQueue()
        
        // create connection on new thread
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error != nil {
                println("Error: \(error)")
                println("Response: \(response)")
                
            } else {
                
                // deserialize json object
                let json = JSON(data: data)
                println("Got \(userid) container under UserAE.")
                println("\n-------------------------------\n")
                
                // extract UserAE container list
                for obj in json["output"]["ResourceOutput"][0]["Attributes"][0] {
                    println(obj.1)
                    
                    // check for queried user id
                    var string: String = obj.1.stringValue
                    if string.rangeOfString(userid, options: nil, range: Range(start: string.startIndex, end: string.endIndex), locale: nil) != nil {
                        println("Found user: \(userid)")
                        self.queriedUser = userid
                        
                        // extract uuid
                        var getUUID = string.lastPathComponent
                        var uuid = getUUID.stringByReplacingOccurrencesOfString("]", withString: "", options: .LiteralSearch, range: nil)
                        println("Found user UUID: \(uuid)")
                        self.queriedUserUUID = uuid
                        
                        // find flag for uuid
                        self.getQueriedUUIDAccuracyFlag(uuid)
                        
                    } else {
                        println("Did not find user.")
                    }
                }
                println("\n-------------------------------\n")
                
                if self.queriedUser == "" {
                    self.displayAlert("Oh no!", error: "Did not find username \(userid)")
                    
                }
            }
        } // end NSURLConnection block
    }
    
    func getQueriedUUIDAccuracyFlag(uuid: String) {
        
        let httpMethod = "GET"
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/AccuracyFlag/?from=http:52.10.62.166:10000&requestIdentifier=12345&resultContent=3"
        
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        
        let queue = NSOperationQueue()
        
        // create connection on new thread
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error != nil {
                println("Error: \(error)")
                println("Response: \(response)")
                
            } else {
                
                // deserialize json object
                let json = JSON(data: data)
                println("Got AccuracyFlag Container for \(uuid)")
                println("\n-------------------------------\n")
                
                // extract UserAE container list
                for obj in json["output"]["ResourceOutput"][0]["Attributes"][3] {
                    println(obj.1)
                    
                    // check for accuracy flag
                    var flag: String = obj.1.stringValue
                    if flag != "labels" {
                        println("Found flag: \(flag)")
                        self.accuracyFlag = flag
                        
                        // pass flag to accurate location decision method
                        self.getMostAccurateLocation(self.accuracyFlag)
                        
                    } else {
                        println("Did not find flag.")
                    }
                }
                println("\n-------------------------------\n")
            }
        } // end NSURLConnection block
    }
    
    func getMostAccurateLocation(flag: String) {
        
        println("Finding best location...")
        
        var locBeaconFlag = flag[flag.startIndex]
        var locCMXFlag = flag[advance(flag.startIndex, 1)]
        var locGPSFlag = flag[advance(flag.startIndex, 2)]
        println("LocBeacon Flag = \(locBeaconFlag)")
        println("LocCMX Flag = \(locCMXFlag)")
        println("LocGPS Flag = \(locGPSFlag)")
        
        // choose best locating method
        if locBeaconFlag == "1" {
            println("Getting beacon location...")
            
            // get beacon indoor position and go to map marker
            self.extractLatestLocBeaconContent()
            
        } else if locBeaconFlag == "0" && locCMXFlag == "1" {
            println("Getting CMX location...")
            
            // get cmx indoor position
            
            
        } else if locBeaconFlag == "0" && locCMXFlag == "0" && locGPSFlag == "1" {
            println("Getting GPS location...")
            
            // get GPS location
            
        } else {
            
            self.displayAlert("Oh no!", error: "Could not find any location for \(self.queriedUser)")
            
        }
    }
    
    
    // MARK: Beacon Query Functions
    
    func extractLatestLocBeaconContent() {
        let httpMethod = "GET"
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+self.queriedUserUUID+"/LocBeacon/latest?from=http:52.10.62.166:10000&requestIdentifier=12345&resultContent=2"
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        
        let queue = NSOperationQueue()
        
        // create connection on new thread
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if error != nil {
                println("Error: \(error)")
                println("Response: \(response)")
                
            } else {
                
                // deserialize json object
                let json = JSON(data: data)
                println("Got latest LocBeacon content.")
                println("\n-------------------------------\n")
                
                // extract gps location content
                for obj in json["output"]["ResourceOutput"][0]["Attributes"][7] {
                    
                    // check for coords
                    var string: NSString = obj.1.stringValue
                    if string != "content" {
                        println("Found indoor location: \(string)!")
                        
                        // split string into map id, x and y
                        var splitString = string.componentsSeparatedByString(",")
                        var mapid = splitString[0] as! NSString
                        var x = splitString[1] as! NSString
                        var y = splitString[2] as! NSString
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            // meanwhile... on the main thread...
                            self.queriedUserBeaconCoordinates = "\(x)" + "," + "\(y)"
                            self.isMappingQueriedUser = true
                            
                            // TODO: update or remove previously drawn object
                            var realX = self.indoorLocationView.calculatePictureCoordinateForRealX(x.doubleValue)
                            var realY = self.indoorLocationView.calculatePictureCoordinateForRealY(y.doubleValue)
                            
                            println("fake X: \(x), fake Y: \(y)")
                            println("real X: \(realX), real Y: \(realY)")
                            
                            self.queriedUserView = UIImageView(image: UIImage(named: "marker_icon.png"))
                            self.indoorLocationView.drawObject(self.queriedUserView, withPosition: ESTPoint(x: x.doubleValue, y: y.doubleValue))
                            
                        })
                        
                    } else {
                        println("Did not find coords.")
                    }
                }
                println("\n-------------------------------\n")
                
                if self.queriedUserBeaconCoordinates == "" {
                    self.displayAlert("Oh no!", error: "Error finding \(self.queriedUser)'s indoor location.")
                    
                }
            }
        } // end NSURLConnection block
    }
    
    // MARK: View Utility Functions
    
    func displayAlert(title:String, error:String) {
        // display error alert
        var errortAlert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        errortAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            // close alert
        }))
        
        self.presentViewController(errortAlert, animated: true, completion: nil)
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}

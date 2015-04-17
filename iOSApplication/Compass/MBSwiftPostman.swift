//
//  MBSwiftPostman.swift
//  Compass
//
//  Created by Mark on 2/27/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import Foundation

class MBSwiftPostman {
    
    // MARK: New User POST Functions
    
    // all new user functions nested
    func createNewUserContainer() {
        
        // set input method
        let httpMethod = "POST"
        
        let userID = PFUser.currentUser().username
        
        // use this url to create new user ID
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkUserAE/?from=http:52.10.62.166:10000&requestIdentifier=12345"
        
        // default JSON payload
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":"",
                "resourceName":userID,
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Setup \(userID) Container.")
            println("\n-------------------------------\n")
            
            self.createUUIDContainerUserAE()
            
        } // end url block
    }
    
    func createUUIDContainerUserAE() {
        
        // set input method
        let httpMethod = "POST"
        
        let userID = PFUser.currentUser().username
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        // use this url to create new UUID
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkUserAE/"+userID+"/?from=http:52.10.62.166:10000&requestIdentifier=12345"
        
        // JSON payload
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":"",
                "resourceName":uuid,
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Setup UUID Container under UserAE.")
            println("\n-------------------------------\n")
            
            self.createUUIDContainerLocationAE()
            
        } // end url block
    }
    
    func createUUIDContainerLocationAE() {
        
        // set input method
        let httpMethod = "POST"
        
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        // use this url to create new UUID
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/?from=http:52.10.62.166:10000&requestIdentifier=12345"
        
        // JSON payload
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":"",
                "resourceName":uuid,
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Setup UUID Container under LocationAE.")
            println("\n-------------------------------\n")
            
            self.createLocBeaconContainer()
            
        } // end url block
    }
    
    func createLocBeaconContainer() {
        
        // set input method
        let httpMethod = "POST"
        
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        // use this url to create new UUID
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/?from=http:52.10.62.166:10000&requestIdentifier=12345"
        
        // JSON payload
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":"",
                "resourceName":"LocBeacon",
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Setup LocBeacon Container.")
            println("\n-------------------------------\n")
            
            self.createLocCMXContainer()
            
        } // end url block
    }
    
    func createLocCMXContainer() {
        
        // set input method
        let httpMethod = "POST"
        
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        // use this url to create new UUID
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/?from=http:52.10.62.166:10000&requestIdentifier=12345"
        
        // JSON payload
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":"",
                "resourceName":"LocCMX",
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Setup LocCMX Container.")
            println("\n-------------------------------\n")
            
            self.createLocGPSContainer()
            
        } // end url block
    }
    
    func createLocGPSContainer() {
    
        // set input method
        let httpMethod = "POST"
        
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        // use this url to create new UUID
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/?from=http:52.10.62.166:10000&requestIdentifier=12345"
        
        // JSON payload
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":"",
                "resourceName":"LocGPS",
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Setup LocGPS Container.")
            println("\n-------------------------------\n")
            
            self.createAccuracyFlagContainer()
            
        } // end url block
    }
    
    func createAccuracyFlagContainer() {
        // set input method
        let httpMethod = "POST"
        
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        
        // use this url to create new UUID
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/?from=http:52.10.62.166:10000&requestIdentifier=12345"
        
        // JSON payload
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":"000",
                "resourceName":"AccuracyFlag",
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Setup AccuracyFlag Container.")
            println("\n-------------------------------\n")
            
        } // end url block
    }
    
    // MARK: LocationAE AccuracyFlag Enable Functions
    
    func getFlagEnableForLocGPS() {
        
        let httpMethod = "GET"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
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
                
                // extract UserAE container list
                for obj in json["output"]["ResourceOutput"][0]["Attributes"][3] {
                    
                    // check for accuracy flag
                    var flag: String = obj.1.stringValue
                    if flag != "labels" {
                        println("Found flag: \(flag)")
                        
                        // parse flag and update it
                        self.putEnableFlagForLocGPS(flag)
                        
                    } else {
                        // did not find flag
                    }
                }
            }
        } // end NSURLConnection block
    }
    
    func putEnableFlagForLocGPS(flag: String) {
        
        let locBeaconFlag = flag[flag.startIndex]
        let locCMXFlag = flag[advance(flag.startIndex, 1)]
        let locGPSFlag = flag[advance(flag.startIndex, 2)]
        
        let newFlag = "\(locBeaconFlag)" + "\(locCMXFlag)" + "1"
        
        // set input method
        let httpMethod = "PUT"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/AccuracyFlag/?from=http:52.10.62.166:10000&requestIdentifier=12345&resultContent=3"
        
        /* use this json payload to update flag label */
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":newFlag,
                "resourceName":"AccuracyFlag",
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Enabled LocGPS flag.")
            
        } // end url block
    }
    
    func getFlagEnableForLocCMX() {
        
    }
    
    func putEnableFlagForLocCMX() {
        
    }
    
    func getFlagEnableForLocBeacon() {
        
        let httpMethod = "GET"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
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
                
                // extract UserAE container list
                for obj in json["output"]["ResourceOutput"][0]["Attributes"][3] {
                    
                    // check for accuracy flag
                    var flag: String = obj.1.stringValue
                    if flag != "labels" {
                        println("Found flag: \(flag)")
                        
                        // parse flag and update it
                        self.putEnableFlagForLocBeacon(flag)
                        
                    } else {
                        // did not find flag
                    }
                }
            }
        } // end NSURLConnection block
    }
    
    func putEnableFlagForLocBeacon(flag: String) {
        
        let locBeaconFlag = flag[flag.startIndex]
        let locCMXFlag = flag[advance(flag.startIndex, 1)]
        let locGPSFlag = flag[advance(flag.startIndex, 2)]
        
        let newFlag = "1" + "\(locCMXFlag)" + "\(locGPSFlag)"
        
        // set input method
        let httpMethod = "PUT"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/AccuracyFlag/?from=http:52.10.62.166:10000&requestIdentifier=12345&resultContent=3"
        
        /* use this json payload to update flag label */
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":newFlag,
                "resourceName":"AccuracyFlag",
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Enabled LocBeacon flag.")
            
        } // end url block
    }
    
    // MARK: LocationAE AccuracyFlag Disable Functions
    
    func getFlagDisableForLocGPS() {
        let httpMethod = "GET"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
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
                
                // extract UserAE container list
                for obj in json["output"]["ResourceOutput"][0]["Attributes"][3] {
                    
                    // check for accuracy flag
                    var flag: String = obj.1.stringValue
                    if flag != "labels" {
                        println("Found flag: \(flag)")
                        
                        // parse flag and update it
                        self.putDisableFlagForLocGPS(flag)
                        
                    } else {
                        // did not find flag
                    }
                }
            }
        } // end NSURLConnection block
    }
    
    func putDisableFlagForLocGPS(flag: String) {
        let locBeaconFlag = flag[flag.startIndex]
        let locCMXFlag = flag[advance(flag.startIndex, 1)]
        let locGPSFlag = flag[advance(flag.startIndex, 2)]
        
        let newFlag = "\(locBeaconFlag)" + "\(locCMXFlag)" + "0"
        
        // set input method
        let httpMethod = "PUT"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/AccuracyFlag/?from=http:52.10.62.166:10000&requestIdentifier=12345&resultContent=3"
        
        /* use this json payload to update flag label */
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":newFlag,
                "resourceName":"AccuracyFlag",
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Disabled LocGPS flag.")
            
        } // end url block
    }
    
    func getFlagDisableForLocCMX() {
        
    }
    
    func putDisableFlagForLocCMX() {
        
    }
    
    func getFlagDisableForLocBeacon() {
        
        let httpMethod = "GET"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
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
                
                // extract UserAE container list
                for obj in json["output"]["ResourceOutput"][0]["Attributes"][3] {
                    
                    // check for accuracy flag
                    var flag: String = obj.1.stringValue
                    if flag != "labels" {
                        println("Found flag: \(flag)")
                        
                        // parse flag and update it
                        self.putDisableFlagForLocBeacon(flag)
                        
                    } else {
                        // did not find flag
                    }
                }
            }
        } // end NSURLConnection block
    }
    
    func putDisableFlagForLocBeacon(flag: String) {
        let locBeaconFlag = flag[flag.startIndex]
        let locCMXFlag = flag[advance(flag.startIndex, 1)]
        let locGPSFlag = flag[advance(flag.startIndex, 2)]
        
        let newFlag = "0" + "\(locCMXFlag)" + "\(locGPSFlag)"
        
        // set input method
        let httpMethod = "PUT"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/AccuracyFlag/?from=http:52.10.62.166:10000&requestIdentifier=12345&resultContent=3"
        
        /* use this json payload to update flag label */
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"container",
            "content": [
                "labels":newFlag,
                "resourceName":"AccuracyFlag",
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Disabled LocBeacon flag.")
            
        } // end url block
    }
    
    
    // MARK: LocationAE POST Functions
    
    func createLocGPSContentInstance(coords: String) {
        // set input method
        let httpMethod = "POST"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/LocGPS/?from=http:52.10.62.166:10000&requestIdentifier=12345&resultContent=3"
        
        /* use this json payload to create content instances */
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"contentInstance",
            "content": [
                "content":coords
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Received response! Created a new content instance in LocGPS!")
            println("\n-------------------------------\n")
            
        } // end url block
    }
    
    func createLocCMXContentInstance() {
        
    }
    
    func createLocBeaconContentInstance(indoorCoords: String) {
        
        // set input method
        let httpMethod = "POST"
        let uuid = UIDevice.currentDevice().identifierForVendor.UUIDString

        // use this url to create contentInstance
        let urlAsString = "http://52.10.62.166:8282/InCSE1/MarkLocationAE/Things/"+uuid+"/LocBeacon/?from=http:52.10.62.166:10000&requestIdentifier=12345"
        
        /* use this json payload to create content instances */
        var params: [NSString : AnyObject] =
        [
            "from":"http:localhost:10000",
            "requestIdentifier":"12345",
            "resourceType":"contentInstance",
            "content": [
                "content":indoorCoords,
            ]
        ]
        
        // url request properties
        let url = NSURL(string: urlAsString)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var err: NSError?
        
        // config request with timeout
        let urlRequest = NSMutableURLRequest(URL: url!, cachePolicy: cachePolicy, timeoutInterval: 15.0)
        urlRequest.HTTPMethod = httpMethod
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("Basic YWRtaW46YWRtaW4=", forHTTPHeaderField: "Authorization")
        urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        
        // init queue
        let queue = NSOperationQueue()
        
        // create connection on a new thread for request
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (reponse: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            // deserialize json object
            let json = JSON(data: data)
            println("Received response! Created a new content instance in LocBeacon!")
            println("\n-------------------------------\n")
            
        } // end url block
    }
}

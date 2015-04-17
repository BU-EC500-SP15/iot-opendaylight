//
//  MBUserLocGPSAnnotation.swift
//  Compass
//
//  Created by Mark on 4/9/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit
import MapKit

class MBUserLocGPSAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String!
    var subtitle = "Tap to Navigate"
    var imageName = "user_marker.png"
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        
        super.init()
    }
    
}

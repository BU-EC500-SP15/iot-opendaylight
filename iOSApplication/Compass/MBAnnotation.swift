//
//  MBAnnotation.swift
//  Compass
//
//  Created by Mark on 3/3/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit
import MapKit

class MBAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var title: String!
    var subtitle = "Indoor Map Available"
    var imageName = "beacon_marker.png"
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        
        super.init()
    }

}

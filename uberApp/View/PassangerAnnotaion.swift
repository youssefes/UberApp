//
//  PassangerAnnotaion.swift
//  uberApp
//
//  Created by youssef on 7/17/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import Foundation
import MapKit

class PassangerAnnotaion: NSObject,MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var key : String
    init(coordinate : CLLocationCoordinate2D, withKey key : String){
        
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
}

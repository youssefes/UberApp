//
//  DriverAnnotation.swift
//  uberApp
//
//  Created by youssef on 7/15/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import Foundation
import MapKit

class DriverAnntation : NSObject, MKAnnotation  {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var key : String
    
    init(coordinate : CLLocationCoordinate2D, withKey key : String){
        
        self.coordinate = coordinate
        self.key = key
        super.init()
    }
    
    func update(AnnotationPosition Annotation : DriverAnntation, withCoordinate coordinate : CLLocationCoordinate2D){
        var location = self.coordinate
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        
        UIView.animate(withDuration: 0.2) {
            self.coordinate = location
        }
        
    }
    
    
}

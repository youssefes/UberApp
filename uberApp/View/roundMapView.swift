//
//  roundMapView.swift
//  uberApp
//
//  Created by youssef on 7/18/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import MapKit

class RoundMapView : MKMapView {
    
    override func awakeFromNib() {
        setup()
    }
    func setup(){
        self.layer.cornerRadius = self.frame.width
        self.layer.borderWidth = 10
        self.layer.borderColor = UIColor.white.cgColor
    }

}

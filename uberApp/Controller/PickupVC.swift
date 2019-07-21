//
//  PickupVC.swift
//  uberApp
//
//  Created by youssef on 7/18/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import MapKit

class PickupVC: UIViewController {
    
    let reduisRegoin : CLLocationDistance = 1000
    var pin : MKPlacemark? = nil
    var pickupCoordinate : CLLocationCoordinate2D!
    var passangerKey : String!
    var locationPlaceMark : MKPlacemark!
    

    @IBOutlet weak var mapViewPickUp: RoundMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapViewPickUp.delegate = self

        locationPlaceMark = MKPlacemark(coordinate: pickupCoordinate)
        dropPin(placeMark: locationPlaceMark)
        centerMapOnLocation(location: locationPlaceMark.location!)
        
    }
    
    
    func initData(coordinate : CLLocationCoordinate2D, passangerKey : String){
        self.passangerKey = passangerKey
        self.pickupCoordinate = coordinate
    }
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func acceptTripBtn(_ sender: Any) {
        
    }
    
    
    

}

extension PickupVC  : MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "PickpuPoint"
        var annotaionView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotaionView == nil{
            annotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }else{
            annotaionView?.annotation = annotation
            
        }
        
        annotaionView?.image = UIImage(named: "destinationAnnotation")
        return annotaionView
    }
    
    func centerMapOnLocation(location : CLLocation){
        let coordinateRegoin = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: reduisRegoin * 2.0, longitudinalMeters: reduisRegoin * 2.0)
        mapViewPickUp.setRegion(coordinateRegoin, animated: true)
    }
    
    func dropPin(placeMark : MKPlacemark){
        pin = placeMark
        
        for annotation in mapViewPickUp.annotations{
            mapViewPickUp.removeAnnotation(annotation)
        }
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placeMark.coordinate
        
        mapViewPickUp.addAnnotation(annotation)
        
        
    }
}

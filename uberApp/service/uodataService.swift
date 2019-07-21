//
//  uodataService.swift
//  uberApp
//
//  Created by youssef on 7/15/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit

class UpdataService{
    static let instance = UpdataService()
    
    
    func UpdataUserLocation(withCoordinate coordinate : CLLocationCoordinate2D){
        
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for usre in userSnapshot{
                    if usre.key == Auth.auth().currentUser?.uid{
                        DataService.instance.REF_USERS.child(usre.key).updateChildValues(["coordinate":[coordinate.latitude,coordinate.longitude]])
                    }
                }
            }
        }
        
    }
    
    func updataDriverLocation(withCoordinate coordinate : CLLocationCoordinate2D){
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for driver in userSnapshot{
                    if driver.key == Auth.auth().currentUser?.uid{
                        if driver.childSnapshot(forPath: "isPickupModeEnable").value as? Bool == true{
                            DataService.instance.REF_DRIVERS.child(driver.key).updateChildValues(["coordinate":[coordinate.latitude,coordinate.longitude]])
                            
                        }
                    }
                }
            }
        }
    }
    
    func observerTrip(handler : @escaping(_ coordinateTrip : Dictionary <String , AnyObject>?)->Void){
        DataService.instance.REF_TRIPS.observe(.value) { (snapShat) in
            
            if let tripCoordinate = snapShat.children.allObjects as? [DataSnapshot]{
                for trip in tripCoordinate{
                    if  trip.hasChild("passangerKey") && trip.hasChild("tripAccept"){
                        if let tripDict = trip.value as? Dictionary<String,AnyObject>{
                            handler(tripDict)
                        }else{
                            handler(nil)
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    
    
    func updataTripsWithCoordinateUponRequest(){
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for usre in userSnapshot{
                    if usre.key == Auth.auth().currentUser?.uid{
                        if !usre.hasChild("userIsDriver"){
                            if let userDict = usre.value as? Dictionary<String,AnyObject>{
                                let PickUpArray = userDict["coordinate"] as! NSArray
                                let distnationArray = userDict["TripCoordinate"] as! NSArray
                                
                                DataService.instance.REF_TRIPS.child(usre.key).updateChildValues(["pickUpCoordinate" : [PickUpArray[0],PickUpArray[1]],"distanitionCoordinate" : [distnationArray[0],distnationArray[2]],"passangerKey" : usre.key,"tripAccept" : false])
                            }
                        }
                    }
                }
            }
        }
        
        
    }
}

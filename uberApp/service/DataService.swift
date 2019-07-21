//
//  DataService.swift
//  uberApp
//
//  Created by youssef on 7/14/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
class DataService{
    static let  instance = DataService()
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_DRIVERS = DB_BASE.child("drivers")
    private var _REF_TRIPS = DB_BASE.child("trips")
    
    
    var REF_BASE : DatabaseReference{
        return _REF_BASE
    }
    
    var REF_USERS : DatabaseReference{
        return _REF_USERS
    }
    var REF_DRIVERS : DatabaseReference{
        return _REF_DRIVERS
    }
    var REF_TRIPS : DatabaseReference{
        
        return _REF_TRIPS
    }
    
    func createFirebaseDBUsre(uid: String, UserData: Dictionary<String,Any> , isDriver : Bool){
        if isDriver{
            REF_DRIVERS.child(uid).updateChildValues(UserData) { (error, datarefrence) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    print("saved")
                }
            }
        }else{
            REF_USERS.child(uid).updateChildValues(UserData) { (error, datarefrence) in
                if error != nil{
                    print(error?.localizedDescription)
                }else{
                    print("saved")
                }
            }
        }
    }
    
    func DriverIsAvailable(Key : String ,handler: @escaping (_ status :Bool)-> Void){
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for driver in userSnapshot{
                    if driver.key == Key{
                        if driver.childSnapshot(forPath: "isPickupModeEnable").value as? Bool == true{
                            if driver.childSnapshot(forPath: "driverOnTrip").value as? Bool == true{
                                handler(false)
                            }else{
                                handler(true)
                            }
                        }
                    }
                }
                
            }
        }
        
    }

}

//
//  SignLoginVc.swift
//  uberApp
//
//  Created by youssef on 7/14/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import Firebase

class SignLoginVc: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var BtnSignUp: RoundShasowButton!
    @IBOutlet weak var passwordTxt: RoundTextField!
    @IBOutlet weak var emailTxt: RoundTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTxt.delegate = self
        emailTxt.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        if passwordTxt.text != nil && emailTxt.text != nil{
            BtnSignUp.animateButton(shouldLoad: true, WithMessage: nil)
            if let email = emailTxt.text ,let passsword = passwordTxt.text{
                Auth.auth().signIn(withEmail: email, password: passsword) { (AuthUser, error) in
                    if error == nil{
                        
                        if let user = AuthUser?.user{
                            if self.segment.selectedSegmentIndex == 0{
                                let userData = ["provider" : user.providerID] as [String : Any]
                                DataService.instance.createFirebaseDBUsre(uid: user.uid, UserData: userData, isDriver: false)
                            }else{
                                let userData = ["provider" : user.providerID, "userIsDriver" : true, "isPickupModeEnable": false,"driverOnTrip" : false] as [String : Any]
                                DataService.instance.createFirebaseDBUsre(uid: user.uid, UserData: userData, isDriver: true)
                            }
                        }
                        
                        
                        print("email is auth Successful Using Firebase")
                        self.dismiss(animated: true, completion: nil)
                        
                    }else{
                        
                        if error != nil{
                            if let errorcode = AuthErrorCode(rawValue: error!._code){
                                switch errorcode{
                                case .wrongPassword:
                                    print("invalid passward please try agin")
                                default :
                                    print("unexpeted  error please try agin")
                                }
                            }
                            
                        }
                        Auth.auth().createUser(withEmail: email, password: passsword, completion: { (userauth, error) in
                            if error != nil{
                                if let errorcode = AuthErrorCode(rawValue: error!._code){
                                    switch errorcode{
                                    case .invalidEmail:
                                        print("Invalid Email please try agin")
                                    case .emailAlreadyInUse:
                                        print("Email Already please try agin")
                                    case .wrongPassword:
                                        print("invalid passward please try agin")
                                    default :
                                        print("unexpeted  error please try agin")
                                    }
                                }
                                
                            }else{
                                print(userauth?.user.uid)
                                if let user = userauth?.user{
                                    print(user)
                                    if self.segment.selectedSegmentIndex == 0{
                                        let userData = ["provider" : user.providerID] as [String : Any]
                                        DataService.instance.createFirebaseDBUsre(uid: user.uid, UserData: userData, isDriver: false)
                                    }else{
                                        let userData = ["provider" : user.providerID,
                                                        "userIsDriver" : true,
                                                        "isPickupModeEnable": false,
                                                        "driverOnTrip" : false] as [String : Any]
                                        DataService.instance.createFirebaseDBUsre(uid: user.uid, UserData: userData, isDriver: true)
                                    }
                                }
                                
                                print("email is auth Successful Using Firebase")
                                self.dismiss(animated: true, completion: nil)
                                
                            }
                        })
                    }
                }
                
            }
            
        }
    }

}

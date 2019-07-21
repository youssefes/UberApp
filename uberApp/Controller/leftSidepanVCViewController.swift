//
//  leftSidepanVCViewController.swift
//  uberApp
//
//  Created by youssef on 7/13/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import Firebase

class leftSidepanVCViewController: UIViewController {
    
    var appDelegat = AppDelegate.GetAppDelegate()
    var currentUID = Auth.auth().currentUser?.uid
    @IBOutlet weak var imageUser: UIImageView!
    
    @IBOutlet weak var switchPickup: UISwitch!
    @IBOutlet weak var pickupMdoelbl: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var accuntTypelbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickupMdoelbl.isHidden = true
        switchPickup.isHidden = true
        switchPickup.isOn = false
        
        observerPassanferAndDriver()
        
        if Auth.auth().currentUser == nil{
            emaillbl.text = ""
            accuntTypelbl.text = ""
            imageUser.isHidden = true
            signUpBtn.setTitle("Sign In / Log in", for: .normal)
        }else{
            emaillbl.text = Auth.auth().currentUser?.email
            accuntTypelbl.text = ""
            imageUser.isHidden = false
            signUpBtn.setTitle("LogOut", for: .normal)
        }

        
    }
    
    
    func observerPassanferAndDriver(){
        
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshat) in
            if let snapsh = snapshat.children.allObjects as? [DataSnapshot]{
                for sanp in snapsh{
                    if sanp.key == Auth.auth().currentUser?.uid{
                        self.accuntTypelbl.text = "PASSANGER"
                    }
                }
            }
        }
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshat) in
            if let snapsh = snapshat.children.allObjects as? [DataSnapshot]{
                for sanp in snapsh{
                    if sanp.key == Auth.auth().currentUser?.uid{
                        self.accuntTypelbl.text = "DRIVER"
                        self.switchPickup.isHidden = false
                        self.pickupMdoelbl.isHidden = false
                        let switchStatas = sanp.childSnapshot(forPath: "isPickupModeEnable").value as! Bool
                        self.switchPickup.isOn = switchStatas
                        
                    }
                }
            }
        }
        
    }
    @IBAction func switchTaggel(_ sender: Any) {
        if switchPickup.isOn{
            pickupMdoelbl.text = "PickUp Model Enable"
        DataService.instance.REF_DRIVERS.child(currentUID!).updateChildValues(["isPickupModeEnable": true])
            appDelegat.Meancontainer.togelleftPanel()
            
        }else{
            pickupMdoelbl.text = "PickUp Model DISEnable"
        DataService.instance.REF_DRIVERS.child(currentUID!).updateChildValues(["isPickupModeEnable": false])
            appDelegat.Meancontainer.togelleftPanel()
        }
    }
    
    @IBAction func signUpLoginBtnPress(_ sender: Any) {
        if Auth.auth().currentUser == nil{
            let storybord = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            let loginVc = storybord.instantiateViewController(withIdentifier: "SignLoginVc") as? SignLoginVc
            present(loginVc!, animated: true, completion: nil)
        }else{
            do{
                try Auth.auth().signOut()
                self.emaillbl.text = ""
                self.accuntTypelbl.text = ""
                self.switchPickup.isHidden = true
                self.pickupMdoelbl.isHidden = true
                self.imageUser.isHidden = true
                signUpBtn.setTitle("Sign In / Log in", for: .normal)
                
            }catch{
                print(error)
            }
        }
        
    }
    
    

}

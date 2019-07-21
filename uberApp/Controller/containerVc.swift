//
//  containerVc.swift
//  uberApp
//
//  Created by youssef on 7/13/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import QuartzCore


enum slideOutstate{
    case collapsed
    case leftpenedExpended
}

enum showWhichVc{
    case HomeVc
}
var showVC : showWhichVc = .HomeVc
class containerVc: UIViewController {

    var ishidden = false
    var centerPanelExpendeOfset : CGFloat = 160
    var homeVc:HomeVc!
    var centerController : UIViewController!
    var leftVc: leftSidepanVCViewController!
    var currentStata:slideOutstate = .collapsed
    var tap : UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()

        initCenter(screen: showVC)
        // Do any additional setup after loading the view.
    }
    func initCenter(screen: showWhichVc ){
        var presentingController : UIViewController
        showVC = screen
        if homeVc == nil {
            homeVc = UIStoryboard.HomeVc()
            homeVc.delegate = self
        }
        presentingController = homeVc
        if let con = centerController{
            con.view.removeFromSuperview()
            con.removeFromParent()
        }
        centerController = presentingController
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return UIStatusBarAnimation.slide
    }
    override var prefersStatusBarHidden: Bool{
        return ishidden
    }
}
extension containerVc : CenterVCDeleget{
    func togelleftPanel() {
        let notAlreadExpended = (currentStata != .leftpenedExpended)
        if notAlreadExpended{
            addleftPanelViewController()
        }
        animateleftPanel(shouldexpend: notAlreadExpended)
    }
    
    func addleftPanelViewController() {
        if leftVc == nil{
            leftVc = UIStoryboard.leftsidepanvc()
            aadChildSildPanelVC(leftVc)
        }
    }
    
    func aadChildSildPanelVC(_ sidePanelController: leftSidepanVCViewController){
        view.insertSubview(sidePanelController.view, at: 0)
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
       
    }
    
    @objc func animateleftPanel(shouldexpend: Bool) {
        if shouldexpend {
            ishidden = !ishidden
            animateStatasBar()
            setUpWhitecover()
            currentStata = .leftpenedExpended
            animateCenterPanelXposition(targget: centerController.view.frame.width - centerPanelExpendeOfset)
        }else{
            ishidden = !ishidden
            animateStatasBar()
            HiddenWhitecover()
            animateCenterPanelXposition(targget: 0) { (finished) in
                if finished == true{
                    self.currentStata = .collapsed
                    self.leftVc = nil
                }
            }
        }
    }
    
    func setUpWhitecover(){
        let Whitecover = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        Whitecover.alpha = 0.0
        Whitecover.backgroundColor = UIColor.white
        Whitecover.tag = 25
        self.centerController.view.addSubview(Whitecover)
        
        Whitecover.fadeTO(alpheValue: 0.75, withDuration: 0.2)
//        UIView.animate(withDuration: 0.2) {
//            Whitecover.alpha = 0.75
//        }
        
        tap = UITapGestureRecognizer(target: self, action: #selector(animateleftPanel(shouldexpend:)))
        tap.numberOfTapsRequired = 1
        self.centerController.view.addGestureRecognizer(tap)
        
    }
    
    func HiddenWhitecover(){
        self.centerController.view.removeGestureRecognizer(tap)
        for subview in self.centerController.view.subviews{
            if subview.tag == 25{
                UIView.animate(withDuration: 0.2, animations: {
                    subview.alpha = 0.0
                }) { (finished) in
                    if finished{
                        subview.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func animateStatasBar(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func animateCenterPanelXposition(targget: CGFloat, complation: ((Bool)->Void)! = nil){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.centerController.view.frame.origin.x = targget
        }, completion: complation)
    }
    
    
}

private extension UIStoryboard{
    class func mainStoryBord()-> UIStoryboard{
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    
    class func leftsidepanvc()-> leftSidepanVCViewController?{
        return mainStoryBord().instantiateViewController(withIdentifier: "leftSidepanVCViewController") as? leftSidepanVCViewController
    }
    
    class func HomeVc()-> HomeVc?{
        return (mainStoryBord().instantiateViewController(withIdentifier: "HomeVc") as? HomeVc)
    }
}

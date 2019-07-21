//
//  RoundShasowButton.swift
//  uberApp
//
//  Created by youssef on 7/13/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class RoundShasowButton: UIButton {

    var originalSize : CGRect?
    override func awakeFromNib() {
        setup()
    }
    func setup(){
        originalSize = self.frame
        self.layer.shadowRadius = 5.0
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
    }
    func animateButton(shouldLoad : Bool, WithMessage message : String?){
        
        let spinner = UIActivityIndicatorView()
        spinner.style = .whiteLarge
        spinner.color = UIColor.darkGray
        spinner.alpha = 0.0
        spinner.hidesWhenStopped = true
        spinner.tag = 21
        if shouldLoad{
            self.addSubview(spinner)
            self.setTitle("", for: .normal)
            UIView.animate(withDuration: 0.2, animations: {
                self.layer.cornerRadius = self.frame.height / 2
                self.frame = CGRect(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height)
            }) { (finished) in
                if finished == true{
                    
                    spinner.startAnimating()
                    spinner.center = CGPoint(x: self.frame.width / 2 + 1, y: self.frame.width / 2 + 1 )
                    spinner.fadeTO(alpheValue: 1.0, withDuration: 0.2)
//                    UIView.animate(withDuration: 0.2, animations: {
//                        spinner.alpha = 1.0
//                    })
                }
            }
            self.isUserInteractionEnabled = false
        }else{
            self.isUserInteractionEnabled = true
            
            for supView in self.subviews{
                if spinner.tag == 21{
                    supView.removeFromSuperview()
                }
            }
            
            UIView.animate(withDuration: 0.2) {
                self.frame = self.originalSize!
                self.layer.cornerRadius = 5.0
                self.setTitle(message, for: .normal)
            }
        }
        
        
    }

}

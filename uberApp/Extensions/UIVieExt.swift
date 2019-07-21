//
//  UIVieExt.swift
//  uberApp
//
//  Created by youssef on 7/14/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

extension UIView{
    func fadeTO(alpheValue : CGFloat, withDuration Duration : TimeInterval){
        UIView.animate(withDuration: Duration) {
            self.alpha = alpheValue
        }
    }
    
//    func boundToKeyBoard(){
//        NotificationCenter.default.addObserver(self, selector: #selector(UIKeyboardchange(_:)), name: UIKeyboardWi, object: nil)
//    }
//    func UIKeyboardchange(_ notification : NSNotification){
//        
//    }
    
}

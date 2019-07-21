//
//  ExUIviewController.swift
//  uberApp
//
//  Created by youssef on 7/17/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func shouldPresentViewLoading(_ status: Bool){
        var Fadeview : UIView = UIView()
        
        if status{
            Fadeview = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            Fadeview.backgroundColor = UIColor.black
            Fadeview.alpha = 0.0
            Fadeview.tag = 99
            
            let spanner = UIActivityIndicatorView()
            spanner.color = UIColor.white
            spanner.style = .whiteLarge
            spanner.center = view.center
           
            view.addSubview(Fadeview)
            Fadeview.addSubview(spanner)
            
            spanner.startAnimating()
            
            Fadeview.fadeTO(alpheValue: 0.7, withDuration: 0.2)
            
        }else{
            for subView in view.subviews{
                if subView.tag == 99{
                    UIView.animate(withDuration: 0.2, animations: {
                        subView.alpha = 0.0
                    }) { (finished) in
                        subView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

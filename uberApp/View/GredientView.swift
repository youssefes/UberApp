//
//  GredientView.swift
//  uberApp
//
//  Created by youssef on 7/13/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class GredientView: UIView {

    let gredient = CAGradientLayer()
    
    override func awakeFromNib() {
        setUpGredientView()
    }
    func setUpGredientView(){
        gredient.frame = self.bounds
        gredient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        gredient.startPoint = CGPoint.zero
        gredient.endPoint = CGPoint.init(x: 0, y: 1)
        gredient.locations = [0.8,1.0]
        self.layer.addSublayer(gredient)
    }

}

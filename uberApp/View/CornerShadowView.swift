//
//  CornerShadowView.swift
//  uberApp
//
//  Created by youssef on 7/13/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class CornerShadowView: UIView {

    override func awakeFromNib() {
        setUpVIew()
    }
    func setUpVIew(){
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 5.0
    }

}

//
//  cornerView.swift
//  uberApp
//
//  Created by youssef on 7/13/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class cornerView: UIView {

    @IBInspectable var bordercolor : UIColor?  {
        didSet{
            setupView()
        }
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = bordercolor?.cgColor
    }

}

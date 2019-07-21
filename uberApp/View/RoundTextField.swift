//
//  RoundTextField.swift
//  uberApp
//
//  Created by youssef on 7/14/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class RoundTextField: UITextField {
    var textOffSet : CGFloat = 20
    override func awakeFromNib() {
        setUpTexteField()
    }
    
    func setUpTexteField(){
        self.layer.cornerRadius = self.frame.height / 2
    
    }

//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: 0 + textOffSet, y: textOffSet, width: self.frame.width - textOffSet, height: self.frame.height)
//    }
//    
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return CGRect(x: 0 + textOffSet, y: textOffSet , width: self.frame.width - textOffSet, height: self.frame.height)
//    }
}

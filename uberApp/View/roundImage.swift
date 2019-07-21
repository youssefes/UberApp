//
//  roundImage.swift
//  uberApp
//
//  Created by youssef on 7/13/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit

class roundImage: UIImageView {

    override func awakeFromNib() {
        setupImageView()
    }
    func setupImageView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}

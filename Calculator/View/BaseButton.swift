//
//  BaseButton.swift
//  Calculator
//
//  Created by 王晓睿 on 17/5/25.
//  Copyright © 2017年 王晓睿. All rights reserved.
//

import UIKit

// 为button加上边框
class BaseButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override func draw(_ rect: CGRect) {
//    init(colorLiteralRed: 184/255.0, green: 184/255.0, blue: 184/255.0, alpha: 1.0)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.25
        self.layer.masksToBounds = true
    }
}

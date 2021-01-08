//
//  UIView+Extensions.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 1/7/21.
//

import Foundation
import UIKit

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 2)
        self.layer.addSublayer(border)
    }
    
    public func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 2)
        self.layer.addSublayer(border)
        
    }
}

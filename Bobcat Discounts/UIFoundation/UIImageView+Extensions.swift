//
//  UIImageView+Extensions.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/21/20.
//

import Foundation
import UIKit

extension UIImageView {
    public func render(with radius: CGFloat) {
        let borderView = UIView()
        borderView.frame = self.bounds
        borderView.layer.cornerRadius = radius
        borderView.layer.masksToBounds = true
        addSubview(borderView)
        
        let subImageView = UIImageView()
        subImageView.image = self.image
        subImageView.frame = borderView.bounds
        borderView.addSubview(subImageView)
    }
}

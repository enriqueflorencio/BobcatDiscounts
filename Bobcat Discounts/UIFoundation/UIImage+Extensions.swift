//
//  UIImage+Extensions.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/1/20.
//

import Foundation
import UIKit

///Extension for downsizing an image from github.
extension UIImage {
    // MARK: Image Resizing
    public func resizeImage() -> UIImage {
        let newSize = CGSize(width: size.width * 0.3, height: size.height * 0.3)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}

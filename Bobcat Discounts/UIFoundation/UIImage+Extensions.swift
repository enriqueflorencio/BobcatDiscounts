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
    public func resizeImage(newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}

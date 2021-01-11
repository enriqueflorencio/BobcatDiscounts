//
//  ImageCache.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 1/3/21.
//

import Foundation
import UIKit

public class ImageCache: NSCache<AnyObject, AnyObject> {
    
    static let shared = ImageCache()
    private override init() {}
    
    public func add(_ image: UIImage, forKey key: String) {
        setObject(image, forKey: key as AnyObject)
    }
    
    public func image(forkey key: String) -> UIImage? {
        guard let image = object(forKey: key as AnyObject) as? UIImage else {
            return nil
        }
        
        return image
    }
}

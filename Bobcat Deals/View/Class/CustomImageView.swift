//
//  CustomImageView.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 1/8/21.
//

import Foundation
import UIKit

public class CustomImageView: UIImageView {
    public var imageUrlString: String?
    private let imageCache = ImageCache.shared
    
    public func loadImageUsingURLString(urlString: String) {
        imageUrlString = urlString
        guard let url = URL(string: urlString) else {
            return
        }
        
        image = nil
        
        if let imageFromCache = imageCache.image(forkey: urlString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data,response,error) in
            guard let self = self else {return}
            if(error != nil) {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)?.resizeImage()
                if(self.imageUrlString == urlString) {
                    self.image = imageToCache
                }
                self.imageCache.add(imageToCache!, forKey: urlString)
            }
        }.resume()
    }
}

//
//  NetworkService.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/24/20.
//

import Foundation
import UIKit

public class NetworkService {
    private let businessURLString = "https://enriqueflorencio.github.io/bobcatdiscounts.github.io/Data/business_data.json"
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    
    public func fetchData(callback: @escaping ([businessInfo]) -> Void) {
        guard let url = URL(string: businessURLString) else { return }
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self,
                  let data = data,
                  let jsonBusiness = try? self.decoder.decode(businessData.self, from: data) else { return }
            callback(jsonBusiness.data.businesses)
            
        }.resume()
        
    }
    
    public func getImage(_ url: String, callback: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                callback(image)
            }
            
        }.resume()
        
    }
    
}

//
//  NetworkService.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/24/20.
//

import Foundation
import UIKit

public class NetworkService {
    
    private let session = URLSession.shared
    private let decoder = JSONDecoder()
    public var task = URLSessionDataTask()
    
    public func fetchData(url: String, callback: @escaping ([businessInfo]) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self,
                  let data = data,
                  let jsonBusiness = try? self.decoder.decode(businessData.self, from: data) else { return }
            callback(jsonBusiness.data.businesses)
            
        }
        task.resume()
    }
    
    public func cancelSession() {
        session.invalidateAndCancel()
        print("cancelling request")
    }
    
    public func getImage(_ url: String, callback: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        
        task = session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                callback(image)
            }
            
        }
        //print(task.state.rawValue)
        task.resume()
        //print(task.state.rawValue)
        
    }
    
}

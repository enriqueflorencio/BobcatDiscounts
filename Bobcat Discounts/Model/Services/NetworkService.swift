//
//  NetworkService.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/24/20.
//

import Foundation

public class NetworkService {
    private var businesses = [businessInfo]()
    private let restaurantURLString = "https://enriqueflorencio.github.io/bobcatdiscounts.github.io/Data/business_data.json"
    
    public func parseData(callback: @escaping ([businessInfo]) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else {
                return
            }
            guard let url = URL(string: self.restaurantURLString),
                  let data = try? Data(contentsOf: url) else {
                return
            }
            self.parse(data)
            
            callback(self.businesses)
        }
        
    }

    private func parse(_ json: Data) {
        let decoder = JSONDecoder()

        guard let jsonRestaurant = try? decoder.decode(businessData.self, from: json) else {
            return
        }
        
        let businessesData = jsonRestaurant.data.businesses
        for elm in businessesData {
            businesses.append(elm)
        }
        
    }
}

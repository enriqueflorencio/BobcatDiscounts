//
//  MapViewModel.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/24/20.
//

import Foundation
import MapKit

public class BusinessMapModel {
    public let businessLatitude: Double
    public let businessLongitude: Double
    public let businessName: String
    public init(businessLatitude: Double, businessLongitude: Double, businessName: String) {
        self.businessLatitude = businessLatitude
        self.businessLongitude = businessLongitude
        self.businessName = businessName
    }
}

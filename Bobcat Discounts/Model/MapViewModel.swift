//
//  MapViewModel.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/24/20.
//

import Foundation
import MapKit

public class MapViewModel {
    public let businessAddress: String
    public let distance: CLLocationDistance
    public let mapRegion: MKCoordinateRegion
    public let annotation: BusinessAnnotation
    public init(businessAddress: String, distance: CLLocationDistance, mapRegion: MKCoordinateRegion, annotation: BusinessAnnotation) {
        self.businessAddress = businessAddress
        self.distance = distance
        self.mapRegion = mapRegion
        self.annotation = annotation
    }
}

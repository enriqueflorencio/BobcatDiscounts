//
//  MapViewCalculatorCalculator.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/28/20.
//

import Foundation
import CoreLocation
import MapKit

public class MapViewCalculator {
    ///The user's current coordinate
    public let currentCoordinate: CLLocationCoordinate2D?
    
    public init(currentCoordinate: CLLocationCoordinate2D) {
        self.currentCoordinate = currentCoordinate
    }
    
    public func createBusinessAnnotation(businessName: String, businessLatitude: Double, businessLongitude: Double) -> BusinessAnnotation {
        let businessInformation = BusinessAnnotation(title: businessName, coordinate: CLLocationCoordinate2D(latitude: businessLatitude, longitude: businessLongitude))
        return businessInformation
    }
    
    //This might need to run on a background thread
    public func direct(businessLatitude: Double, businessLongitude: Double, callback: @escaping (CLLocationDistance) -> Void) {
        guard let currentCoordinate = currentCoordinate else {
            return
        }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (currentCoordinate.latitude), longitude: (currentCoordinate.longitude)), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: businessLatitude, longitude: businessLongitude), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] (response, error) in
            guard let unwrappedResponse = response else {
                return
            }
            
            let route = unwrappedResponse.routes[0] as MKRoute
            let distance = route.distance / 1609
            callback(distance)
        }
    }
    
    public func createRegion(businessLatitude: Double, businessLongitude: Double) -> MKCoordinateRegion? {
        guard let currentCoordinate = currentCoordinate else {
            return nil
        }
        
        let userLatitude = Double(currentCoordinate.latitude)
        let userLongitude = Double(currentCoordinate.longitude)
        var latitudeArray = [userLatitude, businessLatitude]
        var longitudeArray = [userLongitude, businessLongitude]
        latitudeArray.sort()
        longitudeArray.sort()
        
        let smallestLatitude = latitudeArray[0]
        let smallestLongitude = longitudeArray[0]
        guard let biggestLatitude = latitudeArray.last,
              let biggestLongitude = longitudeArray.last else {
            return nil
        }
        
        
        let annotationsCenter = CLLocationCoordinate2DMake((biggestLatitude + smallestLatitude) / 2, (biggestLongitude + smallestLongitude) / 2)
        let annotationsSpan = MKCoordinateSpan(latitudeDelta: (biggestLatitude - smallestLatitude) * 1.75, longitudeDelta: (biggestLongitude - smallestLongitude) * 1.75)
        let region = MKCoordinateRegion(center: annotationsCenter, span: annotationsSpan)
        return region
        
    }
}

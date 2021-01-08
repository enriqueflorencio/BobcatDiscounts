//
//  LocationService.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/23/20.
//

import Foundation
import MapKit

///Protocol that our view controller needs to conform to
public protocol LocationServiceDelegate: class {
    func notifyStatus(status: CLAuthorizationStatus)
}

/// Location Service will act as a wrapper for for the CoreLocation Manager.
public class LocationService: NSObject {
    
    // MARK: Public/Private Variables
    
    ///Our location manager
    public let locationManager: CLLocationManager
    
    ///The view controller will make itself the delegate in order to be notified of any significant changes
    weak public var delegate: LocationServiceDelegate?
    
    ///We'll be storing the user's status to giving us access to their location (always allow, when in use, denied, etc.)
    public var status: CLAuthorizationStatus?
    
    ///The user's current coordinate
    public var currentCoordinate: CLLocationCoordinate2D?
    
    // MARK: Constructor
    
    ///This location service needs a location manager
    public init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    // MARK: Location Manager Setup
    
    ///Set this location service as the delegate of the locationManager
    public func setupLocationServices() {
        locationManager.delegate = self
        ///We want the best available accuracy in order to correctly calculate the user's distance from the dispensary
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        ///Request the user for authorization when using this app
        locationManager.requestWhenInUseAuthorization()
        
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    ///Set our status equal to what the user agreed to. If they denied our permission then we have to show them an alert controller telling them that this app doesn't work without their permission.
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        delegate?.notifyStatus(status: status)
    }
    
    ///We need to update our coordinate variable with the user's current location and we need to setup the bounding box in this function.
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let latestLocation = locations.first else {
            return
        }
        currentCoordinate = latestLocation.coordinate
        
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
        
    }
}

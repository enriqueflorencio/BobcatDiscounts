//
//  BusinessAnnotation.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/23/20.
//

import Foundation
import MapKit

///Annotation for a business that will be displayed onto our MapView
public class BusinessAnnotation: NSObject, MKAnnotation {
    ///Name of the business
    public var title: String?
    ///The coordinates of the business
    public var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}

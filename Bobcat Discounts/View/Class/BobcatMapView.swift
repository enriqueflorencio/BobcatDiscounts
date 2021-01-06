//
//  BobcatMapView.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/25/20.
//

import Foundation
import MapKit

///Replace the mapview you have in locationpopup with this one
public class BobcatMapView: MKMapView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMapView() {
        self.mapType = .standard
        self.isZoomEnabled = false
        self.isScrollEnabled = true
        self.showsUserLocation = true
        self.clipsToBounds = true
        self.layer.cornerRadius = 24
    }
}

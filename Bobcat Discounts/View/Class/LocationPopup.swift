//
//  LocationPopup.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/22/20.
//

import Foundation
import UIKit
import MapKit
import SnapKit

public class LocationPopup: UIView, UIGestureRecognizerDelegate {
    
    private let mapView = BobcatMapView()
    private var container = UIView()
    private var stack = UIStackView()
    private var addressLabel = UILabel()
    private var milesLabel = UILabel()
    private var addressString = ""
    private var milesString = ""
    private var calculator : MapViewCalculator?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureGestureRecognizer()
        configureSelf()
        configureAddress()
        configureStackView()
        configureContainerView()
        animateIn()
    }
    
    convenience init(latitude: Double, longitude: Double, businessName: String, currentCoordinate: CLLocationCoordinate2D) {
        self.init(frame: .zero)
        self.calculator = MapViewCalculator(currentCoordinate: currentCoordinate)
        guard let businessAnnotation = self.calculator?.createBusinessAnnotation(businessName: businessName, businessLatitude: latitude, businessLongitude: longitude),
              let mapRegion = self.calculator?.createRegion(businessLatitude: latitude, businessLongitude: longitude) else {
            return
        }
        
        self.calculator?.direct(businessLatitude: latitude, businessLongitude: longitude, callback: { [weak self] (distance) in
            guard let self = self else {
                return
            }
            self.milesString = "\(distance)"
            self.configureMiles()
        })
        self.addressString = businessName
        
        configureAddress()
        addAnnotation(annotation: businessAnnotation)
        configureRect(businessRegion: mapRegion)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn) {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        } completion: { (complete) in
            if(complete) {
                self.removeFromSuperview()
            }
        }

    }
    
    private func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    private func addAnnotation(annotation: BusinessAnnotation) {
        mapView.addAnnotation(annotation)
    }
    
    private func configureRect(businessRegion: MKCoordinateRegion) {
        mapView.setRegion(businessRegion, animated: true)
    }
    
    private func configureSelf() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        frame = UIScreen.main.bounds
    }
    
    private func configureViewConstraints() {
        mapView.snp.makeConstraints { (make) in
            make.height.equalTo(stack.snp.height).multipliedBy(0.5)
            make.width.equalTo(stack.snp.width)
        }
    }
    
    private func configureAddress() {
        addressLabel.backgroundColor = .white
        addressLabel.text = addressString
        addressLabel.textAlignment = .center
        addressLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 13.0)
        stack.setCustomSpacing(15.0, after: mapView)
        stack.addArrangedSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.width.equalTo(stack.snp.width)
            make.height.equalTo(stack.snp.height).multipliedBy(0.1)
        }
    }
    
    private func configureMiles() {
        milesLabel.backgroundColor = .systemBlue
//        milesLabel.layer.borderColor = UIColor.blue.cgColor
        milesLabel.layer.cornerRadius = 30
        milesLabel.layer.masksToBounds = true
        milesLabel.text = milesString
        milesLabel.textColor = .white
        milesLabel.textAlignment = .center
        milesLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        
        stack.addArrangedSubview(milesLabel)
        
        milesLabel.snp.makeConstraints { (make) in
            make.width.equalTo(stack.snp.width).multipliedBy(0.7)
            make.height.equalTo(stack.snp.height).multipliedBy(0.2)
        }
        stack.setCustomSpacing(15.0, after: addressLabel)
        
    }
    
    private func configureContainerView() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white
        container.layer.cornerRadius = 24
        addSubview(container)
        container.snp.makeConstraints { (make) in
            make.centerX.equalTo(snp.centerX)
            make.centerY.equalTo(snp.centerY)
            make.width.equalTo(snp.width).multipliedBy(0.9)
            make.height.equalTo(snp.height).multipliedBy(0.5)
        }
        
        container.addSubview(stack)
        configureStackViewConstraints()
    }
    
    private func configureStackView() {
        stack = UIStackView(arrangedSubviews: [mapView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        
    }
    
    private func configureStackViewConstraints() {
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(container.snp.top)
            make.bottom.equalTo(container.snp.bottom)
            make.leading.equalTo(container.snp.leading)
            make.trailing.equalTo(container.snp.trailing)
        }
        
        configureViewConstraints()
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: container) == true) {
            return false
        }
        return true
    }
    
    
}

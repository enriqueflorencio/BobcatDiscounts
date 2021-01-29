//
//  LocationPopup.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/22/20.
//

import Foundation
import UIKit
import MapKit
import SnapKit

public protocol LocationPopupDelegate: class {
    func createBookmark(businessModel: BusinessMapModel, address: String, discountDesc: String, category: String) -> Bool
    func deleteBookmark(businessName: String) -> Bool
}

public class LocationPopup: UIView {
    
    private let mapView = BobcatMapView()
    private var container = UIView()
    private var stack = UIStackView()
    private var addressLabel = UILabel()
    private var businessLabel = UILabel()
    private var discountLabel = UILabel()
    private var bookmarkButton = UIButton()
    private var category: String?
    private var businessModel: BusinessMapModel?
    public var milesLabel = UILabel()
    private var isBookmarked = false
    weak public var delegate: LocationPopupDelegate?
    
    public required init(businessMapModel : BusinessMapModel, discountDesc: String, address: String, isBookmarked: Bool, category: String) {
        super.init(frame: .zero)
        self.businessModel = businessMapModel
        self.businessLabel.text = businessMapModel.businessName
        self.discountLabel.text = discountDesc
        self.addressLabel.text = address
        self.category = category
        self.isBookmarked = isBookmarked
        configureSelf()
        configureGestureRecognizer()
        configureStackView()
        configureContainerView()
        configureStackViewConstraints()
        configureMapView()
        configureBusiness()
        configureAddress()
        configureMiles()
        configureBookmarkButton()
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSelf() {
        backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        //MARK: This might need to change when switching to view controller
        frame = UIScreen.main.bounds
        
    }
    
    private func configureGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        tapGestureRecognizer.delegate = self
        self.addGestureRecognizer(tapGestureRecognizer)
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
            make.height.equalTo(snp.height).multipliedBy(0.6)
        }
        container.addSubview(stack)
        
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
        
    }
    
    private func configureMapView() {
        mapView.snp.makeConstraints { (make) in
            make.height.equalTo(stack.snp.height).multipliedBy(0.45)
            make.width.equalTo(stack.snp.width)
        }
        
    }
    
    private func configureBusiness() {
        businessLabel.backgroundColor = .white
        businessLabel.textAlignment = .center
        businessLabel.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        stack.setCustomSpacing(10.0, after: mapView)
        stack.addArrangedSubview(businessLabel)
        businessLabel.snp.makeConstraints { (make) in
            make.width.equalTo(stack.snp.width)
            make.height.equalTo(stack.snp.height).multipliedBy(0.1)
        }
        
    }
    
    private func configureDiscount() {
        discountLabel.backgroundColor = .white
        discountLabel.textAlignment = .center
        discountLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        stack.setCustomSpacing(10.0, after: businessLabel)
        stack.addArrangedSubview(discountLabel)
        discountLabel.snp.makeConstraints { (make) in
            make.width.equalTo(stack.snp.width)
            make.height.equalTo(stack.snp.height).multipliedBy(0.1)
        }
    }
    
    private func configureAddress() {
        addressLabel.backgroundColor = .white
        addressLabel.textAlignment = .center
        addressLabel.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        stack.setCustomSpacing(10.0, after: businessLabel)
        stack.addArrangedSubview(addressLabel)
        addressLabel.snp.makeConstraints { (make) in
            make.width.equalTo(stack.snp.width)
            make.height.equalTo(stack.snp.height).multipliedBy(0.1)
        }
    }
    
    private func configureMiles() {
        milesLabel.backgroundColor = .white
        milesLabel.textAlignment = .center
        milesLabel.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        milesLabel.text = "Calculating Distance.."
        
        stack.addArrangedSubview(milesLabel)
        
        milesLabel.snp.makeConstraints { (make) in
            make.width.equalTo(stack.snp.width)
            make.height.equalTo(stack.snp.height).multipliedBy(0.1)
        }
        stack.setCustomSpacing(10.0, after: addressLabel)
        
    }
    
    private func configureBookmarkButton() {
        if(isBookmarked) {
            bookmarkButton.setTitle("Remove Bookmark", for: .normal)
            bookmarkButton.backgroundColor = .systemRed
        } else {
            bookmarkButton.setTitle("Bookmark", for: .normal)
            bookmarkButton.backgroundColor = .systemBlue
        }
        bookmarkButton.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 24.0)
        bookmarkButton.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        bookmarkButton.clipsToBounds = true
        //bookmarkButton.layer.borderWidth = 2
        
        stack.addArrangedSubview(bookmarkButton)
        
        bookmarkButton.snp.makeConstraints { (make) in
            make.width.equalTo(stack.snp.width).multipliedBy(0.95)
            make.height.equalTo(stack.snp.height).multipliedBy(0.15)
        }
        bookmarkButton.layer.cornerRadius = frame.width * 0.08
        
        stack.setCustomSpacing(10.0, after: milesLabel)
    }
    
    public func addAnnotation(annotation: BusinessAnnotation) {
        mapView.addAnnotation(annotation)
    }
    
    public func configureRect(businessRegion: MKCoordinateRegion) {
        mapView.setRegion(businessRegion, animated: true)
    }

}

extension LocationPopup: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: container) == true) {
            return false
        }
        return true
    }
}

extension LocationPopup {
    // MARK: Animation Methods
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
    
    @objc private func didTap(sender: UIButton) {
        sender.pulsate()
        sender.isEnabled = false ///Remember to renable it after core data saves it or deletes it
        //this can either create the object or delete it depending on what the button looks like
        //and whether or not it was already stored in core data
        //For now we're gonna do a run through of what a CREATE bookmark will look like
        var didComplete : Bool? = false
        if(isBookmarked) {
            didComplete = delegate?.deleteBookmark(businessName: businessLabel.text!)
        } else {
            didComplete = delegate?.createBookmark(businessModel: businessModel!, address: addressLabel.text!, discountDesc: discountLabel.text!, category: category!)
        }
        
        if(didComplete!) {
            isBookmarked = !isBookmarked
            reconfigureBookmarkButton()
        }
        sender.isEnabled = true
        
        
    }
    
    private func reconfigureBookmarkButton() {
        if(isBookmarked) {
            bookmarkButton.setTitle("Remove Bookmark", for: .normal)
            bookmarkButton.backgroundColor = .systemRed
        } else {
            bookmarkButton.setTitle("Bookmark", for: .normal)
            bookmarkButton.backgroundColor = .systemBlue
        }
        
    }
}

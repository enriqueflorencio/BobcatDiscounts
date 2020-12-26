//
//  FeedViewController.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit
import SnapKit
import CoreLocation

public class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LocationServiceDelegate {
    // MARK: Private Variables
    private var feedCollectionView: UICollectionView!
    private var categoryBar: CategoryBar!
    private var businesses = [businessInfo]()
    private var locationService: LocationService?
    private let networkService = NetworkService()

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundColor()
        setupCategoryBar()
        configureFeedCollectionView()
        configureFeedCollectionViewConstraints()
        checkLocationServices()
        fetchData()
    }
    
    private func configureBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setupCategoryBar() {
        categoryBar = CategoryBar()
        view.addSubview(categoryBar)
        categoryBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(65)
        }
    }
    
    private func configureFeedCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width * 0.90, height: view.frame.height * 0.4)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 25
        
        feedCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        feedCollectionView.dataSource = self
        feedCollectionView.delegate = self
        feedCollectionView.showsVerticalScrollIndicator = true
        feedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        feedCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: "FeedCell")
        feedCollectionView.backgroundColor = .white
        view.addSubview(feedCollectionView)
    }
    
    private func configureFeedCollectionViewConstraints() {
        feedCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(categoryBar.snp.bottom)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func checkLocationServices() {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationService = LocationService(locationManager: locationManager)
        locationService?.setupLocationServices()
        locationService?.delegate = self
    }
    
    private func fetchData() {
        networkService.parseData { [weak self] (businessData) in
            guard let self = self else {
                return
            }
            
            self.businesses = businessData
            
            DispatchQueue.main.async {
                self.feedCollectionView.reloadData()
            }
        }
    }
    
    ///Call this function to present an alert controller to the user if they denied us from using their location
    public func presentAlertController() {
        let ac = UIAlertController(title: "WARNING:", message: "Bobcat Discounts neeeds access to your location in order to deliver a satisfying experience. Please change your settings to grant us access to your location.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    private func configurePopUp(_ mapViewModel: MapViewModel) {
        let popup = LocationPopup(mapViewModel: mapViewModel)
        view.addSubview(popup)
    }
    
    // MARK: Collection View Data Source Methods
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCollectionViewCell else {
            fatalError("Could not dequeue reusable cell")
        }
        
        cell.itemImageURL = businesses[indexPath.row].itemImageURL
        cell.discountDescription = businesses[indexPath.row].description
        cell.businessName = businesses[indexPath.row].businessName
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    
    // MARK: Collection View Delegation Methods
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBusiness = businesses[indexPath.row]
        guard let latitude  = selectedBusiness.latitude,
              let longitude = selectedBusiness.longitude,
              let businessName = selectedBusiness.businessName else {
            return
        }
        
        
        
        guard let mapRegion = locationService?.createRegion(businessLatitude: latitude, businessLongitude: longitude),
              let businessAnnotation = locationService?.createBusinessAnnotation(businessName: businessName, businessLatitude: latitude, businessLongitude: longitude) else {
            return
        }
        
        
        locationService?.direct(businessLatitude: latitude, businessLongitude: longitude, callback: { [weak self] (distance) in
            let mapViewModel = MapViewModel(businessAddress: businessName, distance: distance, mapRegion: mapRegion, annotation: businessAnnotation)
            self?.configurePopUp(mapViewModel)
            
        })
//        locationService?.delegate = nil
        
    }
    
    private func beginUpdatingLocation() {
        locationService?.locationManager.startUpdatingLocation()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: {
            guard let cell = collectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell else {
                fatalError()
            }
            
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3, animations: {
            guard let cell = collectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell else {
                fatalError()
            }
            
            cell.backgroundColor = .white
            
        })
    }
    
    public func notifyStatus(status: CLAuthorizationStatus) {
        ///If the user has denied us from using their location
        if(status == .denied) {
            presentAlertController()
            ///Potentially need to disable some features here
        } else {
            beginUpdatingLocation()
        }
    }

}
/// Put this somewhere better later
let imageCache = NSCache<AnyObject, AnyObject>()

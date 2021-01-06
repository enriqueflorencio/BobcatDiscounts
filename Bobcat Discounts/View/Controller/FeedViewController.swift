//
//  FeedViewController.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit
import SnapKit
import CoreLocation
import MapKit

public class FeedViewController: UIViewController {
    // MARK: Private Variables
    private var feedCollectionView: UICollectionView!
    private var categoryBar: CategoryBar!
    private var businesses = [businessInfo]()
    private var locationService: LocationService?
    private let networkService = NetworkService()
    private var persistenceService = PersistenceService.shared
    private let imgCache = ImageCache()
    private var milesDict = [String: Double]()
    private var regionDict = [String: MKCoordinateRegion]()

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
        
        ///Create a custom layout and collectionview so we don't have to waste time here
        
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
        feedCollectionView.register(FeedSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
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
    
    private func configureMap(mapopup: LocationPopup?, mapService: MapService?, businessModel: BusinessMapModel) {
        guard let mapPopup = mapopup,
              let mapService = mapService else {
            return
        }
        mapPopup.addAnnotation(annotation: mapService.createBusinessAnnotation(businessName: businessModel.businessName, businessLatitude: businessModel.businessLatitude, businessLongitude: businessModel.businessLongitude))
        if let region = regionDict[businessModel.businessName] {
            print("region hit")
            mapPopup.configureRect(businessRegion: region)
        } else {
            print("region miss")
            guard let region = mapService.createRegion(businessLatitude: businessModel.businessLatitude, businessLongitude: businessModel.businessLongitude) else {
                return
            }
            mapPopup.configureRect(businessRegion: region)
            regionDict[businessModel.businessName] = region
        }
        
        
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
    
    
    
    private func beginUpdatingLocation() {
        locationService?.locationManager.startUpdatingLocation()
    }
    
    private func checkCache(imgUrl: String?, callback: @escaping (UIImage?) -> Void) {
        guard let imageUrl = imgUrl else {
            return
        }
        
        ///If the image is already in the cache then don't make the request and update the imageView to what's in the cache
        if let imageFromCache = imgCache.image(forkey: imageUrl) {
            callback(imageFromCache)
        }
        ///Cache miss and so we make the network request
        networkService.fetchImage(imageUrl) { [weak self] (data) in
            guard let self = self else {
                return
            }
            ///Resize the image to optimize memory usage and insert it into the cache
            guard let imageToCache = UIImage(data: data)?.resizeImage() else {
                return
            }
            self.imgCache.add(imageToCache, forKey: imageUrl)
            callback(imageToCache)
        }
    }
    
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCollectionViewCell else {
            fatalError("Could not dequeue reusable cell")
        }
        
        checkCache(imgUrl: businesses[indexPath.row].itemImageURL) { [weak self] (image) in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                cell.itemImageView.image = image
            }
        }
        
        checkCache(imgUrl: businesses[indexPath.row].businessImageURL) { [weak self] (image) in
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                cell.businessImageView.image = image
            }
        }
        
//        cell.itemImageURL = businesses[indexPath.row].itemImageURL
        cell.discountDescription = businesses[indexPath.row].description
        cell.businessName = businesses[indexPath.row].businessName
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 7
        
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
             let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! FeedSectionHeader
             sectionHeader.sectionLabel.text = "All Deals"
             return sectionHeader
        } else {
             return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedBusiness = businesses[indexPath.row]
        guard let latitude  = selectedBusiness.latitude,
              let longitude = selectedBusiness.longitude,
              let businessName = selectedBusiness.businessName,
              let businessAddress = selectedBusiness.address,
              let discountDesc = selectedBusiness.description,
              let currentCoordinate = locationService?.currentCoordinate else {
            return
        }
        
        let isBookmarked = persistenceService.fetchBusiness(businessName)
        print(isBookmarked)
        
        let mapService = MapService(currentCoordinate: currentCoordinate)
        let businessModel = BusinessMapModel(businessLatitude: latitude, businessLongitude: longitude, businessName: businessName)
        //var mapPopup = LocationPopup2()
        
        let mapPopup = LocationPopup(business: businessName, discountDesc: discountDesc, address: businessAddress, isBookmarked: isBookmarked)
        mapPopup.delegate = self
        self.view.addSubview(mapPopup)
        self.configureMap(mapopup: mapPopup, mapService: mapService, businessModel: businessModel)
        
        if let miles = milesDict[businessName] {
            print("cache hit")
            mapPopup.milesLabel.text = String(format: "%.1f Miles Away", miles)
        } else {
            print("cache miss")
            mapService.direct(businessLatitude: latitude, businessLongitude: longitude) { [weak self] (miles) in
                guard let self = self else {
                    return
                }
                self.milesDict[businessName] = miles
                
                mapPopup.milesLabel.text = String(format: "%.1f Miles Away", miles)
                
            }
        }
        
        
        
        
//        locationService?.delegate = nil
        
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
}

extension FeedViewController: LocationServiceDelegate {
    public func notifyStatus(status: CLAuthorizationStatus) {
        ///If the user has denied us from using their location
        if(status == .denied) {
            presentAlertController()
        } else {
            beginUpdatingLocation()
        }
    }
}

extension FeedViewController: LocationPopupDelegate {
    public func createBookmark(businessName: String, address: String, discountDesc: String) -> Bool {
        let bookmark = Bookmark(context: persistenceService.context)
        bookmark.businessName = businessName
        bookmark.address = address
        bookmark.discountdesc = discountDesc
        let isSaved = persistenceService.save()
        return isSaved
    }
    
    public func deleteBookmark(businessName: String) -> Bool {
        let didDelete = persistenceService.deleteBookmark(businessName)
        return didDelete
    }
    
    
}

///I don't like this too much... try and do something different when cleaning up the project
public class FeedSectionHeader: SectionHeader {
    public override func configureConstraints() {
        sectionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top).offset(15)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing)
        }
    }
}

/// Put this somewhere better later
let imageCache = NSCache<AnyObject, AnyObject>()

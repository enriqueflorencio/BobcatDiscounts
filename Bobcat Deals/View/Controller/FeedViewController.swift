//
//  FeedViewController.swift
//  Bobcat Deals
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
    private var persistenceService = PersistenceService()
    private let imgCache = ImageCache.shared
    private var milesDict = [String: Double]()
    private var regionDict = [String: MKCoordinateRegion]()
    private var businessURLString = "https://enriqueflorencio.github.io/bobcatdiscounts.github.io/Data/Restaurants_data.json"
    private let mapService = MapService.shared

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundColor()
        setupCategoryBar()
        configureFeedCollectionView()
        configureFeedCollectionViewConstraints()
        checkLocationServices()
        fetchData(businessURL: businessURLString)
    }
    
    private func configureBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func setupCategoryBar() {
        categoryBar = CategoryBar()
        categoryBar.delegate = self
        view.addSubview(categoryBar)
        categoryBar.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.12)
        }
    }
    
    public override func viewDidLayoutSubviews() {
        categoryBar.addTopBorderWithColor(color: .lightGray, width: categoryBar.frame.size.width)
        categoryBar.addBottomBorderWithColor(color: .lightGray, width: categoryBar.frame.size.width)
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
            mapPopup.configureRect(businessRegion: region)
        } else {
            guard let region = mapService.createRegion(businessLatitude: businessModel.businessLatitude, businessLongitude: businessModel.businessLongitude) else {
                return
            }
            mapPopup.configureRect(businessRegion: region)
            regionDict[businessModel.businessName] = region
        }

    }
    
    private func fetchData(businessURL: String) {
        networkService.fetchData(url: businessURL) { [weak self] (businessData) in
            
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
        let ac = UIAlertController(title: "WARNING:", message: "Bobcat Deals neeeds access to your location in order to deliver a satisfying experience. Please change your settings to grant us access to your location.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    private func beginUpdatingLocation() {
        locationService?.locationManager.startUpdatingLocation()
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
        cell.currentItemURL = businesses[indexPath.row].itemImageURL
        cell.category = businesses[indexPath.row].category
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
              let category = selectedBusiness.category,
              let businessAddress = selectedBusiness.address,
              let discountDesc = selectedBusiness.description,
              let currentCoordinate = locationService?.currentCoordinate else {
            return
        }
        let isBookmarked = persistenceService.fetchBusiness(businessName)
        let businessModel = BusinessMapModel(businessLatitude: latitude, businessLongitude: longitude, businessName: businessName)
        
        let mapPopup = LocationPopup(businessMapModel: businessModel, discountDesc: discountDesc, address: businessAddress, isBookmarked: isBookmarked, category: category)
        mapPopup.delegate = self
        self.view.addSubview(mapPopup)
        self.configureMap(mapopup: mapPopup, mapService: mapService, businessModel: businessModel)
        
        if let miles = milesDict[businessName] {
            mapPopup.milesLabel.text = String(format: "%.1f Miles Away", miles)
        } else {
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
        UIView.animate(withDuration: 0.1, animations: {
            guard let cell = collectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell else {
                fatalError()
            }
            
            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            
        })
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1, animations: {
            guard let cell = collectionView.cellForItem(at: indexPath) as? FeedCollectionViewCell else {
                fatalError()
            }
            
            cell.backgroundColor = .white
            
        })
    }
}

extension FeedViewController: LocationServiceDelegate {
    public func updatedUserCoordinate(currentCoordinate: CLLocationCoordinate2D) {
        mapService.currentCoordinate = currentCoordinate
    }
    
    public func notifyStatus(status: CLAuthorizationStatus) {
        ///If the user has denied us from using their location
        if(status == .denied) {
            presentAlertController()
        } else {
            beginUpdatingLocation()
        }
    }
}

extension FeedViewController: CategoryDelegate {
    public func fetchBusinesses(category: String) {
        businessURLString = "https://enriqueflorencio.github.io/bobcatdiscounts.github.io/Data/\(category)_data.json"
        fetchData(businessURL: businessURLString)
    }
}

extension FeedViewController: LocationPopupDelegate {
    public func createBookmark(businessModel: BusinessMapModel, address: String, discountDesc: String, category: String) -> Bool {
        let bookmark = Bookmark(context: persistenceService.context)
        bookmark.businessName = businessModel.businessName
        bookmark.category = category
        bookmark.latitude = businessModel.businessLatitude
        bookmark.longitude = businessModel.businessLongitude
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

//
//  FeedViewController.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit
import SnapKit

public class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: Private Variables
    private var feedCollectionView: UICollectionView!
    private var categoryBar: CategoryBar!
    private var practiceRestuarantImage = UIImageView()
    private var practiceFoodImage = UIImageView()
    private var businesses = [businessInfo]()

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackgroundColor()
        setupCategoryBar()
        configureFeedCollectionView()
        configureFeedCollectionViewConstraints()
        parseData()
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
    
    //Delete later
    
    private func parseData() {
        let restaurantURLString = "https://enriqueflorencio.github.io/bobcatdiscounts.github.io/Data/business_data.json"
        if let url = URL(string: restaurantURLString) {
            if let data = try? Data(contentsOf: url) {
                parse(data)
            }
        }
    }

    private func parse(_ json: Data) {
        let decoder = JSONDecoder()

        if let jsonRestaurant = try? decoder.decode(businessData.self, from: json) {
            
            var businessData = jsonRestaurant.data
            var businessesFromAPI = businessData.businesses
            for elm in businessesFromAPI {
                businesses.append(elm)
            }
            print(businesses.count)
//            practiceRestaurant.businessName = jsonRestaurant.businessName
//            practiceRestaurant.businessImageURL = jsonRestaurant.businessImageURL
//            practiceRestaurant.itemImageURL = jsonRestaurant.itemImageURL
//            practiceRestaurant.description = jsonRestaurant.description
        }
        
        feedCollectionView.reloadData()


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

}
/// Put this somewhere better later
let imageCache = NSCache<AnyObject, AnyObject>()

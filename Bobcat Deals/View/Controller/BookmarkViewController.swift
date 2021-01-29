//
//  BookmarkViewController.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit
import SnapKit
import MapKit

//public class BookmarkViewController: UIViewController {
//
//    private var bookedCollectionView : UICollectionView!
//    private var persistenceService = PersistenceService()
//    private let refreshControl = UIRefreshControl()
//    private var bookmarks = [Bookmark]()
//    private var messageLabel = UILabel()
//    private var milesDict = [String: Double]()
//    private var regionDict = [String: MKCoordinateRegion]()
//    private let mapService = MapService.shared
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//        configureBackgroundColor()
//        getBookmarks()
//        configureCollectionView()
//        configureEmptyMessageLabel()
//    }
//
//    private func configureBackgroundColor() {
//        view.backgroundColor = .white
//    }
//
//    private func getBookmarks() {
//        let fetchedbookmarks = persistenceService.fetch(Bookmark.self)
//        bookmarks = fetchedbookmarks
//    }
//
//    private func configureCollectionView() {
//        refreshControl.addTarget(self, action: #selector(refreshBookmarks), for: .valueChanged)
//        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
//        bookedCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: UICollectionViewFlowLayout())
//        guard let layout = bookedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
//            return
//        }
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.15)
//        layout.scrollDirection = .vertical
//        layout.sectionHeadersPinToVisibleBounds = true
//        layout.minimumLineSpacing = 15
//        bookedCollectionView.dataSource = self
//        bookedCollectionView.delegate = self
//        bookedCollectionView.refreshControl = refreshControl
//        bookedCollectionView.showsVerticalScrollIndicator = true
//        bookedCollectionView.isScrollEnabled = true
//        bookedCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        bookedCollectionView.register(BookedCollectionViewCell.self, forCellWithReuseIdentifier: "BookedCell")
//        bookedCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
//        bookedCollectionView.backgroundColor = .white
//        view.addSubview(bookedCollectionView)
//
//        bookedCollectionView.snp.makeConstraints { (make) in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.equalTo(view.snp.leading)
//            make.trailing.equalTo(view.snp.trailing)
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
//    }
//
//    private func configureEmptyMessageLabel() {
//        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bookedCollectionView.bounds.size.width, height: bookedCollectionView.bounds.size.height))
//        messageLabel.textColor = .black
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = .center
//        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
//        messageLabel.sizeToFit()
//    }
//
//    @objc private func refreshBookmarks(_ sender: Any) {
//        getBookmarks()
//        bookedCollectionView.reloadData()
//        refreshControl.endRefreshing()
//    }
//
//    private func configureMap(mapopup: LocationPopup?, mapService: MapService?, businessModel: BusinessMapModel) {
//        guard let mapPopup = mapopup,
//              let mapService = mapService else {
//            return
//        }
//        mapPopup.addAnnotation(annotation: mapService.createBusinessAnnotation(businessName: businessModel.businessName, businessLatitude: businessModel.businessLatitude, businessLongitude: businessModel.businessLongitude))
//        if let region = regionDict[businessModel.businessName] {
//            mapPopup.configureRect(businessRegion: region)
//        } else {
//            guard let region = mapService.createRegion(businessLatitude: businessModel.businessLatitude, businessLongitude: businessModel.businessLongitude) else {
//                return
//            }
//            mapPopup.configureRect(businessRegion: region)
//            regionDict[businessModel.businessName] = region
//        }
//
//    }
//
//}
//
//extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if(bookmarks.count == 0) {
//            messageLabel.text = "Uh-oh! Looks Like You Don't Have Any Bookmarks Yet!"
//            bookedCollectionView.backgroundView = messageLabel
//        } else {
//            bookedCollectionView.backgroundView = nil
//        }
//        return bookmarks.count
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookedCell", for: indexPath) as? BookedCollectionViewCell else {
//            fatalError("Could not dequeue reusable cell")
//        }
//
//
//        cell.businessName = bookmarks[indexPath.item].businessName
//        cell.discountDescription = bookmarks[indexPath.item].discountdesc
//        cell.backgroundColor = .white
//        return cell
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if (kind == UICollectionView.elementKindSectionHeader) {
//             let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
//             sectionHeader.sectionLabel.text = "My Bookmarks"
//             return sectionHeader
//        } else {
//             return UICollectionReusableView()
//        }
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let isBookmarked = persistenceService.fetchBusiness(bookmarks[indexPath.item].businessName)
//        let businessModel = BusinessMapModel(businessLatitude: bookmarks[indexPath.item].latitude, businessLongitude: bookmarks[indexPath.item].longitude, businessName: bookmarks[indexPath.item].businessName)
//
//        let mapPopup = LocationPopup(businessMapModel: businessModel, discountDesc: bookmarks[indexPath.item].discountdesc, address: bookmarks[indexPath.item].address, isBookmarked: isBookmarked)
//        mapPopup.delegate = self
//        self.view.addSubview(mapPopup)
//        self.configureMap(mapopup: mapPopup, mapService: mapService, businessModel: businessModel)
//
//        if let miles = milesDict[bookmarks[indexPath.item].businessName] {
//            mapPopup.milesLabel.text = String(format: "%.1f Miles Away", miles)
//        } else {
//            mapService.direct(businessLatitude: bookmarks[indexPath.item].latitude, businessLongitude: bookmarks[indexPath.item].longitude) { [weak self] (miles) in
//                guard let self = self else {
//                    return
//                }
//                self.milesDict[self.bookmarks[indexPath.item].businessName] = miles
//
//                mapPopup.milesLabel.text = String(format: "%.1f Miles Away", miles)
//
//            }
//        }
//
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: 50)
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.1, animations: {
//            guard let cell = collectionView.cellForItem(at: indexPath) as? BookedCollectionViewCell else {
//                fatalError()
//            }
//
//            cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
//
//        })
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.1, animations: {
//            guard let cell = collectionView.cellForItem(at: indexPath) as? BookedCollectionViewCell else {
//                fatalError()
//            }
//
//            cell.backgroundColor = .white
//
//        })
//    }
//}
//
//extension BookmarkViewController: LocationPopupDelegate {
//    public func createBookmark(businessModel: BusinessMapModel, address: String, discountDesc: String) -> Bool {
//        let bookmark = Bookmark(context: persistenceService.context)
//        bookmark.businessName = businessModel.businessName
//        bookmark.latitude = businessModel.businessLatitude
//        bookmark.longitude = businessModel.businessLongitude
//        bookmark.address = address
//        bookmark.discountdesc = discountDesc
//        let isSaved = persistenceService.save()
//        return isSaved
//    }
//
//    public func deleteBookmark(businessName: String) -> Bool {
//        let didDelete = persistenceService.deleteBookmark(businessName)
//        return didDelete
//    }
//
//
//}

public class BookmarkViewController: UIViewController {
    private let sectionLabel = UILabel()
    private var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private var persistenceService = PersistenceService()
    private var bookmarks = [Bookmark]()
    private var messageLabel = UILabel()
    private var milesDict = [String: Double]()
    private var regionDict = [String: MKCoordinateRegion]()
    private let mapService = MapService.shared
    
    override public func viewDidLoad() {
        configureSelf()
        configureBookmarkLabel()
        getBookmarks()
        configureTableView()
        configureEmptyMessageLabel()
    }
    
    private func configureSelf() {
        view.backgroundColor = .white
    }
    
    private func configureBookmarkLabel() {
        sectionLabel.text = "Bookmarks"
        sectionLabel.textColor = UIColor.black
        sectionLabel.textAlignment = .left
        sectionLabel.backgroundColor = .white
        sectionLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        sectionLabel.sizeToFit()
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sectionLabel)
        
        sectionLabel.snp.makeConstraints { (make) in
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
            make.width.equalTo(view.snp.width)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
        }
    }
    
    private func getBookmarks() {
        let fetchedbookmarks = persistenceService.fetch(Bookmark.self)
        bookmarks = fetchedbookmarks
    }
    
    
    private func configureTableView() {
        refreshControl.addTarget(self, action: #selector(refreshBookmarks), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .lightGray
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl
        //tableView.estimatedRowHeight = view.frame.height * 0.10
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.register(BookedTableViewCell.self, forCellReuseIdentifier: "book")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(sectionLabel.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func configureEmptyMessageLabel() {
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
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
    
    @objc private func refreshBookmarks(_ sender: Any) {
        getBookmarks()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension BookmarkViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(bookmarks.count == 0) {
            messageLabel.text = "Uh-oh! Looks Like You Don't Have Any Bookmarks Yet!"
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return bookmarks.count
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isBookmarked = persistenceService.fetchBusiness(bookmarks[indexPath.item].businessName)
        let businessModel = BusinessMapModel(businessLatitude: bookmarks[indexPath.item].latitude, businessLongitude: bookmarks[indexPath.item].longitude, businessName: bookmarks[indexPath.item].businessName)

        let mapPopup = LocationPopup(businessMapModel: businessModel, discountDesc: bookmarks[indexPath.item].discountdesc, address: bookmarks[indexPath.item].address, isBookmarked: isBookmarked, category: bookmarks[indexPath.item].category)
        mapPopup.delegate = self
        self.view.addSubview(mapPopup)
        self.configureMap(mapopup: mapPopup, mapService: mapService, businessModel: businessModel)

        if let miles = milesDict[bookmarks[indexPath.item].businessName] {
            mapPopup.milesLabel.text = String(format: "%.1f Miles Away", miles)
        } else {
            mapService.direct(businessLatitude: bookmarks[indexPath.item].latitude, businessLongitude: bookmarks[indexPath.item].longitude) { [weak self] (miles) in
                guard let self = self else {
                    return
                }
                self.milesDict[self.bookmarks[indexPath.item].businessName] = miles

                mapPopup.milesLabel.text = String(format: "%.1f Miles Away", miles)

            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "book") as? BookedTableViewCell else {
            fatalError("could not dequeue cell")
        }
        
        cell.businessName = bookmarks[indexPath.row].businessName
        cell.discountDescription = bookmarks[indexPath.row].discountdesc
        cell.category = bookmarks[indexPath.row].category
        cell.backgroundColor = .white
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.15
    }
    
}

extension BookmarkViewController: LocationPopupDelegate {
    public func createBookmark(businessModel: BusinessMapModel, address: String, discountDesc: String, category: String) -> Bool {
        let bookmark = Bookmark(context: persistenceService.context)
        bookmark.businessName = businessModel.businessName
        bookmark.latitude = businessModel.businessLatitude
        bookmark.category = category
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

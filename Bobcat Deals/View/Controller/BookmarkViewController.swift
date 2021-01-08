//
//  BookmarkViewController.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit
import SnapKit

public class BookmarkViewController: UIViewController {
    
    private var bookedCollectionView : UICollectionView!
    private var persistenceService = PersistenceService()
    private let refreshControl = UIRefreshControl()
    private var bookmarks = [Bookmark]()
    private var messageLabel = UILabel()
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundColor()
        getBookmarks()
        configureCollectionView()
        configureEmptyMessageLabel()
    }
    
    private func configureBackgroundColor() {
        view.backgroundColor = .white
    }
    
    private func getBookmarks() {
        let fetchedbookmarks = persistenceService.fetch(Bookmark.self)
        bookmarks = fetchedbookmarks
    }
    
    private func configureCollectionView() {
        
        
        
        refreshControl.addTarget(self, action: #selector(refreshBookmarks), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        
        bookedCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: UICollectionViewFlowLayout())
        guard let layout = bookedCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height * 0.15)
        layout.scrollDirection = .vertical
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 25
        bookedCollectionView.dataSource = self
        bookedCollectionView.delegate = self
        //bookedCollectionView.indicatorStyl
        bookedCollectionView.refreshControl = refreshControl
        bookedCollectionView.showsVerticalScrollIndicator = true
        bookedCollectionView.isScrollEnabled = true
        bookedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bookedCollectionView.register(BookedCollectionViewCell.self, forCellWithReuseIdentifier: "BookedCell")
        bookedCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        bookedCollectionView.backgroundColor = .white
        view.addSubview(bookedCollectionView)
        
        bookedCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func configureEmptyMessageLabel() {
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bookedCollectionView.bounds.size.width, height: bookedCollectionView.bounds.size.height))
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
    }
    
    
    
    @objc private func refreshBookmarks(_ sender: Any) {
        getBookmarks()
        bookedCollectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

extension BookmarkViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(bookmarks.count == 0) {
            messageLabel.text = "Uh-oh! Looks Like You Don't Have Any Bookmarks Yet!"
            bookedCollectionView.backgroundView = messageLabel
        } else {
            bookedCollectionView.backgroundView = nil
        }
        return bookmarks.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookedCell", for: indexPath) as? BookedCollectionViewCell else {
            fatalError("Could not dequeue reusable cell")
        }
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 7
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
             let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
             sectionHeader.sectionLabel.text = "Bookmarks"
             return sectionHeader
        } else {
             return UICollectionReusableView()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}

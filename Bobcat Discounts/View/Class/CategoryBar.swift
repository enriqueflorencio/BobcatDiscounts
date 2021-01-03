//
//  CategoryBar.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/3/20.
//

import UIKit
import SnapKit

public class CategoryBar: UIView {
    private var categoryCollectionView: UICollectionView!
    private let imageNames = ["restaurants", "dessert", "other"]
    private let cellId = "categoryCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCategoryCollectionView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCategoryCollectionView() {
        let layout = UICollectionViewFlowLayout()
        categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        categoryCollectionView.backgroundColor = .white
        categoryCollectionView.layer.borderColor = UIColor.gray.cgColor
        categoryCollectionView.layer.borderWidth = 2
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        categoryCollectionView.showsHorizontalScrollIndicator = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        addSubview(categoryCollectionView)
        
    }
    
    private func configureConstraints() {
        categoryCollectionView.snp.makeConstraints { (make) in
            make.height.equalTo(snp.height)
            make.width.equalTo(snp.width)
        }
    }
    
}

extension CategoryBar: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CategoryCollectionViewCell else {
            fatalError("Failed to dequeue reusable cell")
        }
        
        cell.categoryString = imageNames[indexPath.item]
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 3 , height: frame.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

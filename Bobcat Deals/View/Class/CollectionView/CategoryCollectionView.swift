//
//  CategoryCollectionView.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/7/20.
//

import UIKit
import SnapKit

public class CategoryCollectionViewCell: UICollectionViewCell {
    
    public var categoryString: String? {
        didSet {
            configureImage()
            configureLabel()
        }
    }
    
    private var categoryImage = UIImageView()
    public var categoryLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImage() {
        categoryImage.image = UIImage(named: categoryString!)
        categoryImage.contentMode = .scaleAspectFit
        addSubview(categoryImage)
        categoryImage.snp.makeConstraints({ (make) in
            make.width.equalTo(snp.width).multipliedBy(0.5)
            make.height.equalTo(snp.height).multipliedBy(0.7)
            make.top.equalTo(snp.top)
            make.centerX.equalTo(snp.centerX)
        })
    }
    
    private func configureLabel() {
        categoryLabel.text = categoryString!
        categoryLabel.font = UIFont.systemFont(ofSize: 15)
        categoryLabel.textAlignment = .center
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(categoryImage.snp.bottom)
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.3)
            make.centerX.equalTo(snp.centerX)
        }
    }
}

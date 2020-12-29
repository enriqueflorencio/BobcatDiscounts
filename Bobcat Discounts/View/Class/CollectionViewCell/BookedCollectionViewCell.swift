//
//  BookedCollectionViewCell.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/29/20.
//

import UIKit

class BookedCollectionViewCell: UICollectionViewCell {
    private var businessImageView = UIImageView()
    private var businessLabel = UILabel()
    private var addressLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBusinessImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        businessImageView.layer.cornerRadius = (businessImageView.frame.width) / 2
        businessImageView.layer.borderWidth = 1.0
        businessImageView.layer.borderColor = UIColor.green.cgColor
    }
    
    private func configureBusinessImageView() {
        businessImageView.image = UIImage(named: "restaurants")
        businessImageView.layer.masksToBounds = false
        businessImageView.backgroundColor = .white
        businessImageView.clipsToBounds = true
        businessImageView.contentMode = .scaleAspectFill
        addSubview(businessImageView)
        businessImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(snp.height).multipliedBy(0.9)
            make.leading.equalTo(snp.leading).offset(5)
            make.top.equalTo(snp.top).offset(5)
        }
        
        
    }
}

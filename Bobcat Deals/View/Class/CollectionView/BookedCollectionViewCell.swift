//
//  BookedCollectionViewCell.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/29/20.
//

import UIKit

class BookedCollectionViewCell: UICollectionViewCell {
    private var businessImageView = UIImageView()
    private var businessLabel = UILabel()
    private var addressLabel = UILabel()
    private var descriptionLabel = UILabel()
    public var businessName: String? {
        didSet {
            businessLabel.text = businessName
        }
    }
    
    public var discountDescription: String? {
        didSet {
            descriptionLabel.text = discountDescription
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBusinessImageView()
        configureBusinessLabel()
        configureDescriptionLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        businessImageView.layer.cornerRadius = (businessImageView.frame.width) / 2
        businessImageView.layer.borderWidth = 1.0
        businessImageView.layer.borderColor = UIColor.black.cgColor
        //self.addTopBorderWithColor(color: .lightGray, width: self.frame.size.width)
        self.addBottomBorderWithColor(color: .lightGray, width: self.frame.size.width)
        self.addTopBorderWithColor(color: .lightGray, width: self.frame.size.width)
        print(businessImageView.frame.size.height)
    }
    
    private func configureBusinessImageView() {
        businessImageView.image = UIImage(named: "Restaurants")
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
    
    private func configureBusinessLabel() {
        businessLabel.textColor = UIColor.black
        businessLabel.textAlignment = .left
        businessLabel.font = UIFont.systemFont(ofSize: 18)
        addSubview(businessLabel)
        businessLabel.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.2)
            make.top.equalTo(businessImageView.snp.top).offset(self.frame.size.height * 0.2)
            make.leading.equalTo(businessImageView.snp.trailing).offset(10)
        }
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.textColor = UIColor.systemBlue
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.2)
            make.top.equalTo(businessLabel.snp.bottom).offset(10)
            make.leading.equalTo(businessImageView.snp.trailing).offset(10)
        }
    }
    

}

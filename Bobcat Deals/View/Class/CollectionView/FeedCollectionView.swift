//
//  FeedCollectionView.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit
import SnapKit

///Collection View Cell that will be used to display businesses to the user
public class FeedCollectionViewCell: UICollectionViewCell {
    // MARK: Image Views
    public var itemImageView = CustomImageView()
    public var businessImageView = CustomImageView()
    // MARK: Labels
    public var descriptionLabel = UILabel()
    public var businessNameLabel = UILabel()
    //MARK: Descriptions
    public var discountDescription: String? {
        didSet {
            descriptionLabel.text = discountDescription
        }
    }
    
    public var currentItemURL: String? {
        didSet {
            if let currentURL = currentItemURL {
                itemImageView.loadImageUsingURLString(urlString: currentURL)
            }
        }
    }
    public var currentbusinessURL: String? {
        didSet {
            if let currentURL = currentbusinessURL {
                businessImageView.loadImageUsingURLString(urlString: currentURL)
            }
        }
    }
    
    public var businessName: String? {
        didSet {
            businessNameLabel.text = businessName
        }
    }
    
    // MARK: Constructor Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureItemImageView()
        configureBusinessImageView()
        configureDescriptionLabel()
        configurebusinessNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        itemImageView.image = nil
        businessImageView.image = nil
        descriptionLabel.text = nil
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        businessImageView.layer.cornerRadius = (businessImageView.frame.width) / 2
        businessImageView.layer.borderWidth = 1.0
        businessImageView.layer.borderColor = UIColor.gray.cgColor
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 6.0
        layer.shadowOpacity = 0.6
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.textColor = UIColor.systemBlue
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        descriptionLabel.text = discountDescription
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.top.equalTo(businessImageView.snp.bottom)
            make.leading.equalTo(snp.leading).offset(10)
        }
    }
    
    private func configurebusinessNameLabel() {
        businessNameLabel.textColor = UIColor.black
        businessNameLabel.textAlignment = .left
        businessNameLabel.font = UIFont.systemFont(ofSize: 18)
        businessNameLabel.text = businessName
        addSubview(businessNameLabel)
        businessNameLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(30)
            make.top.equalTo(descriptionLabel.snp.bottom).inset(5)
            make.leading.equalTo(snp.leading).offset(10)
        }
    }
    
    private func configureItemImageView() {
        self.backgroundColor = .white
        addSubview(itemImageView)
        itemImageView.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width)
            make.height.equalTo(snp.height).multipliedBy(0.6)
            make.top.equalTo(snp.top)
            make.centerX.equalTo(snp.centerX)
        }
        itemImageView.contentMode = .scaleAspectFill
        itemImageView.layer.borderWidth = 1.0
        itemImageView.layer.cornerRadius = 7
        itemImageView.layer.masksToBounds = false
        itemImageView.clipsToBounds = true
    }
    
    private func configureBusinessImageView() {
        businessImageView.layer.borderWidth = 1.0
        businessImageView.contentMode = .scaleAspectFill
        businessImageView.layer.masksToBounds = false
        businessImageView.clipsToBounds = true
        businessImageView.backgroundColor = .white
        addSubview(businessImageView)
        businessImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(snp.height).multipliedBy(0.2)
            make.top.equalTo(itemImageView.snp.bottom).inset(25)
            make.leading.equalTo(snp.leading).offset(20)
        }
        businessImageView.image = UIImage(named: "Restaurants")
    }
    
}

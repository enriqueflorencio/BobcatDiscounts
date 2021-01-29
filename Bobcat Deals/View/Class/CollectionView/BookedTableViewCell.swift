//
//  BookedTableViewCell.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 1/14/21.
//

import UIKit

class BookedTableViewCell: UITableViewCell {
    
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
    
    public var category: String? {
        didSet {
            if let currentCategory = category {
                switch currentCategory {
                case "Restaurant":
                    businessImageView.image = UIImage(named: "Restaurants")
                case "Dessert":
                    businessImageView.image = UIImage(named: "Dessert")
                case "Other":
                    businessImageView.image = UIImage(named: "Other")
                default:
                    break
                }
            }
        }
    }

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureBusinessImageView()
        configureBusinessLabel()
        configureDescriptionLabel()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        businessImageView.layer.cornerRadius = (businessImageView.frame.width) / 2
        businessImageView.layer.borderWidth = 1.0
        businessImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        businessImageView.image = nil
        descriptionLabel.text = nil
        businessLabel.text = nil
        addressLabel.text = nil
    }
    
    private func configureBusinessImageView() {
        businessImageView.image = nil
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
            make.height.equalTo(snp.height).multipliedBy(0.25)
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
            make.top.equalTo(businessLabel.snp.bottom).offset(20)
            make.leading.equalTo(businessImageView.snp.trailing).offset(10)
        }
    }

}

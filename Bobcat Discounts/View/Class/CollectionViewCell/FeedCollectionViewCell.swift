//
//  FeedCollectionViewCell.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit
import SnapKit

///Collection View Cell that will be used to display businesses to the user
public class FeedCollectionViewCell: UICollectionViewCell {
    // MARK: Image Views
    public var itemImageView = UIImageView()
    public var businessImageView = UIImageView()
    // MARK: Labels
    public var descriptionLabel = UILabel()
    // MARK: Image URLS
    public var itemImageURL: String? {
        didSet {
            fetchImagesFromURLs()
            configureItemImageView()
            configureBusinessImageView()
        }
    }
    //MARK: Descriptions
    public var discountDescription: String? {
        didSet {
            configureDescriptionLabel()
        }
    }
    
    // MARK: Constructor Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        itemImageView.image = nil
        businessImageView.image = nil
        descriptionLabel.text = nil
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 11.0)
        descriptionLabel.text = discountDescription
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.top.equalTo(businessImageView.snp.bottom)
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
        //foodImageView.layer.cornerRadius = foodImageView.image!.size.width / 2
        itemImageView.layer.masksToBounds = false
        itemImageView.clipsToBounds = true
    }
    
    private func configureBusinessImageView() {
        businessImageView.layer.borderWidth = 1.0
        //businessImageView.layer.borderColor = UIColor.white.cgColor
        //businessImageView.layer.cornerRadius = businessImageView.frame.size.width / 2
        businessImageView.layer.masksToBounds = false
        businessImageView.clipsToBounds = true
        businessImageView.backgroundColor = .white
        addSubview(businessImageView)
        businessImageView.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width).multipliedBy(0.2)
            make.height.equalTo(snp.height).multipliedBy(0.2)
            make.top.equalTo(itemImageView.snp.bottom).inset(25)
            make.leading.equalTo(snp.leading).offset(20)
        }
        businessImageView.image = UIImage(named: "restaurants")
    }
    
    
    
    private func fetchImagesFromURLs() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let url = URL(string: (self?.itemImageURL!)!) else {
                return
            }
            
            ///If the image is already in the cache then don't make the request and update the imageView to what's in the cache
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                ///Updates to the UI run on the main thread
                DispatchQueue.main.async { [weak self] in
                    self?.itemImageView.image = imageFromCache
                }
                
            } else {
                ///Cache miss and so we make the network request
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                ///Resize the image to optimize memory usage and insert it into the cache
                guard let imageToCache = UIImage(data: data) else {
                    return
                }
                imageCache.setObject(imageToCache, forKey: url as AnyObject)
                ///Updates to the UI occur on the main thread
                DispatchQueue.main.async { [weak self] in
                    self?.itemImageView.image = imageToCache
                }
            }
            
            
        }
    }
    
}

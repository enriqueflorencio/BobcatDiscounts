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
    public var foodImageView = UIImageView()
    public var businessImageView = UIImageView()
    // MARK: Labels
    public var businessLabel = UILabel()
    
    // MARK: Constructor Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBusinessLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        foodImageView.image = nil
        businessImageView.image = nil
        businessLabel.text = nil
    }
    
    private func configureBusinessLabel() {
        businessLabel.textColor = UIColor.black
        businessLabel.textAlignment = .center
        businessLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 11.0)
        businessLabel.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        businessLabel.layer.cornerRadius = 7
    }
    
}

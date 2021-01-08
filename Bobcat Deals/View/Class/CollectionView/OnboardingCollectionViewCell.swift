//
//  OnboardingCollectionViewCell.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/8/20.
//

import UIKit
import SnapKit
import Lottie
public class OnboardingCollectionViewCell: UICollectionViewCell {
    private let descriptionLabel = UILabel()
    public let animationView = AnimationView()
    public var descriptionString: String? {
        didSet {
            descriptionLabel.text = descriptionString
        }
        
    }
    public var animationString: String? {
        didSet {
            animationView.animation = Animation.named(animationString!)
            animationView.play()
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureAnimation()
        configureDescriptionLabel()
        //configureNextButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        animationView.animation = nil
        descriptionLabel.text = nil
    }
    
    
    private func configureAnimation() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        
        animationView.loopMode = .loop
        addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width).multipliedBy(0.8)
            make.height.equalTo(snp.height).multipliedBy(0.50)
            make.centerY.equalTo(snp.centerY)
            make.centerX.equalTo(snp.centerX)
        }
        
        
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.text = ""
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = UIFont(name: "AvenirNext-Medium", size: 16.0)
        descriptionLabel.textAlignment = .center
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(animationView.snp.bottom)
            make.width.equalTo(snp.width).multipliedBy(0.9)
            make.height.equalTo(snp.height).multipliedBy(0.1)
            make.centerX.equalTo(snp.centerX)
        }
        
    }
    
}

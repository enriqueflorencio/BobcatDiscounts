//
//  OnboardingCollectionViewCell.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/8/20.
//

import UIKit
import SnapKit
import Lottie

public protocol OnboardingCellDelegate : class {
    func moveFrame()
}

public class OnboardingCollectionViewCell: UICollectionViewCell {
    private let descriptionLabel = UILabel()
    private let animationView = AnimationView()
    public var nextButton = NextButton()
    public weak var delegate: OnboardingCellDelegate?
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
        configureNextButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        animationView.animation = nil
        descriptionLabel.text = nil
    }
    
    
    private func configureAnimation() {
        //animationView.animation = Animation.named(animationString!)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1
        animationView.loopMode = .loop
        addSubview(animationView)
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width).multipliedBy(0.8)
            make.height.equalTo(snp.height).multipliedBy(0.35)
            make.centerY.equalTo(snp.centerY).multipliedBy(0.8)
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
            make.top.equalTo(animationView.snp.bottom).offset(30)
            make.width.equalTo(snp.width).multipliedBy(0.9)
            make.height.equalTo(snp.height).multipliedBy(0.1)
            make.centerX.equalTo(snp.centerX)
        }
        
    }
    
    private func configureNextButton() {
        nextButton.set(title: "Next", backgroundColor: UIColor.systemYellow)
        nextButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.width.equalTo(snp.width).multipliedBy(0.8)
            make.height.equalTo(snp.height).multipliedBy(0.08)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        sender.pulsate()
        delegate?.moveFrame()
    }
    
}

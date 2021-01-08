//
//  OnboardingViewController.swift
//  Bobcat Deals
//
//  Created by Enrique Florencio on 12/8/20.
//

import UIKit
import SnapKit
import Lottie

public class OnboardingViewController: UIViewController {
    
    private let animationStrings = ["restaurant", "idcard", "bookmark"]
    private let infoStrings = ["Find businesses in Merced that offer discounts to UC Merced students!", "Please have your student ID present when making a purchase.", "Bookmark discounts that you might want to reference later!"]
    private var collectionView: UICollectionView!
    private let cellID = "onBoardingCell"
    private let pageControl = UIPageControl()
    private var startButton = StartButton()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSelf()
        configureCollectionView()
        configureCollectionViewConstraints()
        configurePageControl()
        configureStartButton()
    }
    
    private func configureSelf() {
        view.backgroundColor = .white
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.scrollDirection = .horizontal
        //layout.minimumLineSpacing = 1
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        //collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
    }
    
    private func configureCollectionViewConstraints() {
        collectionView.snp.makeConstraints { (make) in
            ///Remember to test the top against different devices, it might look good on the ipod touch but it might also look bad on something else
//            make.top.equalTo(view.snp.top)
//            make.leading.equalTo(view.snp.leading)
//            make.trailing.equalTo(view.snp.trailing)
//            make.bottom.equalTo(view.snp.bottom).multipliedBy(0.6)
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.70)
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    
    private func configurePageControl() {
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.width.equalTo(view.snp.width)
        }
    }
    
    private func configureStartButton() {
        startButton.set(title: "Get Started", backgroundColor: UIColor.systemGreen)
        startButton.addTarget(self, action: #selector(didFinish), for: .touchUpInside)
        view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.top.equalTo(pageControl.snp.bottom)
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(view.snp.height).multipliedBy(0.1)
            make.centerX.equalTo(view.snp.centerX)
        }
        startButton.layer.cornerRadius = view.frame.width * 0.08
    }
    
    private func presentMainApp() {
        let vc = MainTabBarViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc private func didFinish(sender: UIButton) {
        sender.pulsate()
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isOnboarded")
        presentMainApp()
    }
    
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = infoStrings.count
        return infoStrings.count
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? OnboardingCollectionViewCell else {
            fatalError()
        }
        cell.backgroundColor = .white
        cell.animationString = animationStrings[indexPath.item]
        cell.descriptionString = infoStrings[indexPath.item]
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

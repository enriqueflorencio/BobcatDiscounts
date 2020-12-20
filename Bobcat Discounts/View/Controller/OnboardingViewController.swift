//
//  OnboardingViewController.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 12/8/20.
//

import UIKit
import SnapKit
import Lottie

public class OnboardingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, OnboardingCellDelegate {
    
    private let animationStrings = ["restaurant", "idcard", "bookmark"]
    private let infoStrings = ["Find businesses in Merced that offer discounts to UC Merced students!", "Please have your student ID present when making a purchase", "Bookmark discounts that you might want to reference later!"]
    private var collectionView: UICollectionView!
    private let cellID = "onBoardingCell"

    public override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
        configureCollectionViewConstraints()
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
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    private func configureCollectionViewConstraints() {
        collectionView.snp.makeConstraints { (make) in
            ///Remember to test the top against different devices, it might look good on the ipod touch but it might also look bad on something else
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func presentMainApp() {
        let vc = MainTabBarViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(navVC, animated: true)
    }
    
    // MARK: Data Source Methods
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return infoStrings.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? OnboardingCollectionViewCell else {
            fatalError()
        }
        if(indexPath.item == infoStrings.count - 1) {
            cell.nextButton.backgroundColor = .systemGreen
            cell.nextButton.setTitle("Get Started", for: .normal)
        }
        cell.backgroundColor = .white
        cell.animationString = animationStrings[indexPath.item]
        cell.descriptionString = infoStrings[indexPath.item]
        cell.delegate = self
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: OnboardingCell Delegation Methods
    
    public func moveFrame() {
        guard let centerindex = getCenterIndex() else {
            return
        }
        
        switch centerindex.item {
        case infoStrings.count - 1:
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "isOnboarded")
            presentMainApp()
        default:
            let nextItem = centerindex.item + 1
            let nextIndexPath = IndexPath(item: nextItem, section: 0)
            collectionView.scrollToItem(at: nextIndexPath, at: .right, animated: true)
        }
        
    }
    
    private func getCenterIndex() -> IndexPath? {
        ///Take the center of the view controllers space itself and converting it to the space of the view I'm interested in which in this case is the collection view
        let center = self.view.convert(self.collectionView.center, to: self.collectionView)
        let index = collectionView.indexPathForItem(at: center)
        return index
    }
    
}

//
//  ViewController.swift
//  Bobcat Discounts
//
//  Created by Enrique Florencio on 11/30/20.
//

import UIKit

public class MainTabBarViewController: UITabBarController {
    
    // MARK: View Controller Life Cycle Methods

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureBackground()
        configureViewControllers()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    }

    override public func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
    }
    
    private func configureBackground() {
        view.backgroundColor = .white
    }
    
    private func configureViewControllers() {
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        let bookmarkViewController = BookmarkViewController()
        bookmarkViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        viewControllers = [feedViewController, bookmarkViewController]
    }


}


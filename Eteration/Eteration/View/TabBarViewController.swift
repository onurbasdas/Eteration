//
//  TabBarViewController.swift
//  Eteration
//
//  Created by Onur on 2.02.2024.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initilazeView()
        tabBar.backgroundColor = UIColor.white
    }
    
    private func initilazeView() {
        let homeVC = HomeViewController()
        let cardVC = CardViewController()
        let favoriteVC = FavoriteViewController()
        let profileVC = ProfileViewController()
        
        let homeNavController = UINavigationController(rootViewController: homeVC)
        let cardNavController = UINavigationController(rootViewController: cardVC)
        let favoriteNavController = UINavigationController(rootViewController: favoriteVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)
        
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: nil)
        cardVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "cart"), selectedImage: nil)
        favoriteVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "star"), selectedImage: nil)
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: nil)
        
        viewControllers = [homeNavController, cardNavController, favoriteNavController, profileNavController]
        setupTabBar()
    }
    
    private func setupTabBar() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let delegate = windowScene.delegate as? SceneDelegate,
           let window = delegate.window {
            window.rootViewController = UINavigationController(rootViewController: self)
            window.makeKeyAndVisible()
        }
    }
}

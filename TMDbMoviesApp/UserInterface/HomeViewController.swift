//
//  HomeViewController.swift
//  TMDbMoviesApp
//
//  Created by Pradeep Gianchandani on 26/03/24.
//

import UIKit

class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = TabItem.allCases.map { createNavController(for: $0) }
    }
    
    fileprivate func createNavController(for tabProperty: TabItem) -> UIViewController {
        let viewController: UIViewController
        switch tabProperty {
            case .popular:
                viewController = PopularMoviesController()
            case .latest:
                viewController = LatestMoviesController()
        }
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = tabProperty.title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = tabProperty.title
        navController.tabBarItem.image = UIImage(named: tabProperty.imageName)
        return navController
    }
    
    
}

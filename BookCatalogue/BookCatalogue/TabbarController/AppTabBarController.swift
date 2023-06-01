//
//  AppTabBarController.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//


import Foundation
import UIKit
enum TabBarIndex: Int {
   case home = 0, fav
}


@objc class AppTabBarController: UITabBarController {
    
    private let tabBarHomeController: HomeNavViewController!
    /*private let tabBarEkgNavController: TabBarEcgNavController!*/
    private let tabBarFavNavController: FavouriteNavViewController! /* This controller is a an empty placeholder for the tab content, it doesn't contain any information */
  
    
    private let normalTitleFont = UIFont.systemFont(ofSize: 16)
    private let selectedTitleFont = UIFont.systemFont(ofSize: 16)
    
    // TODO(rex): remove tabBarDebugNavController after all features are implemented.
//    private var tabBarDebugNavController: TabBarDebugNavController!
    
     init() {
         self.tabBarHomeController = HomeNavViewController()
         self.tabBarFavNavController = FavouriteNavViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configureTabBarAppearance()
        configureTabBarItems()
    }
    
    func showMainViewController() {
        selectedIndex = TabBarIndex.home.rawValue
    }
    
    func navigateToFavTab() {
        selectedIndex = TabBarIndex.fav.rawValue
        
    }
  
    func dismissPresentedViewContrllers() {
        defer {
            dismiss(animated: false)
        }
        guard let viewControllers = viewControllers else {
            return
        }
        for viewController in viewControllers {
            if viewController.presentedViewController != nil {
                viewController.dismiss(animated: false)
            }
        }
    }
    
}

// MARK: - private

private extension AppTabBarController {
    
    func configureTabBarAppearance() {
        tabBar.tintColor = UIColor(red: 87/255, green: 107/255, blue: 197/255, alpha: 1.0)
        tabBar.backgroundImage = UIImage(named: "")
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 251/255, alpha: 1.0)
    }
    
    func configureTabBarItems() {

        tabBarHomeController.tabBarItem = TabBarItem(title: "Home", image: UIImage(named:"home-deselect"), selectedImage: UIImage(named:"home-selected"), tag: TabBarIndex.home.rawValue)
        
        tabBarFavNavController.tabBarItem = TabBarItem(title: "Favourites", image: UIImage(named:"business-deselect"), selectedImage: UIImage(named:"business-selected"), tag: TabBarIndex.fav.rawValue)
        
      
        /* Adding placeholder for the ECG tab bar */
       /*tabBarEkgNavController.tabBarItem = UITabBarItem(title: LocalizedStrings.TabBar.ekg, image: UIImage(named:"heart"), tag: TabBarIndex.ekg.rawValue)*/

        //tabBarDebugNavController.tabBarItem = UITabBarItem(title: "DEBUG:KardiaMobile)", image: nil, tag: TabBarIndex.debug.rawValue)
        
        viewControllers = [tabBarHomeController, tabBarFavNavController]
    }


}

// MARK: - UITabBarControllerDelegate

extension AppTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let attrsNormal = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]
        let attrsSelected = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]
        for tItem in tabBar.items ?? []{
            let tItem1 = tItem as UITabBarItem
            if tItem1 == item{
                tItem1.setTitleTextAttributes(attrsSelected, for: .normal)
            }else{
                tItem1.setTitleTextAttributes(attrsNormal, for: .normal)
            }
        }
    }
    
}

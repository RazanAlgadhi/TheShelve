//
//  AppNavController.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//



import Foundation
import UIKit

class AppNavController: UINavigationController {
   
     var _appTabBarController: AppTabBarController?
    
   var appTabBarController: AppTabBarController {
        if _appTabBarController == nil {
            _appTabBarController = AppTabBarController()
        }
        return _appTabBarController!
    }
    
    lazy var homeViewController: HomeViewController = {
       let vc = HomeViewController(viewModel: HomeViewModel())
       return vc
   }()
    
     lazy var favViewController: FavouriteViewController = {
        let vc = FavouriteViewController(viewModel: FavouriteViewModel())
        return vc
    }()
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    
    init() {
        super.init(nibName: nil, bundle: nil)
        startApplicationFlow()
        setNavigationBarHidden(true, animated: false)
    }
    
    private func configureNotifications() {
        
    }
    
    lazy var loginScreen: LoginViewController = {
          let vc = LoginViewController(viewModel: LoginViewModel())
          return vc
      }()

    @objc  func goToLoginScreen() {
           viewControllers = [loginScreen]
           setNavigationBarHidden(true, animated: false)
       }

    func startApplicationFlow() {
        goToLoginScreen()
    }
    
    
    func showHomeViewController() {
       dismissPresentedViewContrllers()
        setViewControllers([appTabBarController], animated: true)
        appTabBarController.showMainViewController()
    }
 
   
}

// MARK: private

 extension AppNavController {
    
    func dismissPresentedViewContrllers() {
        topViewController?.dismiss(animated: false)
        if _appTabBarController != nil {            appTabBarController.dismissPresentedViewContrllers()
        }
        dismiss(animated: false)
        self._appTabBarController = nil
    }
}

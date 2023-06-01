//
//  HomeNavViewController.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import UIKit

class HomeNavViewController: UINavigationController {
    init() {
    super.init(nibName: nil, bundle: nil)
    setNavigationBarHidden(true, animated: true)
    let vc = HomeViewController(viewModel: HomeViewModel())
    viewControllers = [vc]
   
}

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}

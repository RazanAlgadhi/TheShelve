//
//  TabBarItem.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import Foundation


import UIKit

class TabBarItem: UITabBarItem {
    
    init(title:String, image:UIImage?, selectedImage: UIImage?, tag: Int) {
        super.init()
        self.title = title
        self.image = image
        self.tag = tag
        self.selectedImage = selectedImage
        let attrsNormal = [NSAttributedString.Key.font : UIFont.systemFont(ofSize:12.0)]
        let attrsSelected = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12.0)]
        if self.tag == 0 {
            self.setTitleTextAttributes(attrsSelected, for: .normal)
        } else {
            self.setTitleTextAttributes(attrsNormal, for: .normal)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

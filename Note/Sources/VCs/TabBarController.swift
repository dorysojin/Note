//
//  TabBarController.swift
//  Note
//
//  Created by 박소진 on 2022/01/19.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarBackgroundColor()
    }
    
    func setTabBarBackgroundColor() {
        tabBar.barTintColor = .white
        tabBar.backgroundColor = .white
        tabBar.layer.borderColor = UIColor.white.cgColor
        tabBar.clipsToBounds = true
        }
}

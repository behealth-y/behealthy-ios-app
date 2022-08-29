//
//  TabBarViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/29.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        tabBar.tintColor = UIColor.init(named: "mainColor")
        tabBar.unselectedItemTintColor = UIColor.init(named: "mainColor")
        
        let firstNav = UINavigationController.init(rootViewController: HomeViewController())
        
        self.viewControllers = [firstNav]
        
        let firstTabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        firstTabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        firstNav.tabBarItem = firstTabBarItem
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct TabBarViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        TabBarViewController()
    }
}

struct TabBarViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        TabBarViewControllerPresentable()
            .ignoresSafeArea()
    }
}

#endif

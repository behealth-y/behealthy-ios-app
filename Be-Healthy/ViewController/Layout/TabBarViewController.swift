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
        let secondNav = UINavigationController.init(rootViewController: HomeViewController())
        let thirdNav = UINavigationController.init(rootViewController: HomeViewController())
        let fourthNav = UINavigationController.init(rootViewController: HomeViewController())
        let fifthNav = UINavigationController.init(rootViewController: HomeViewController())
        
        self.viewControllers = [firstNav, secondNav, thirdNav, fourthNav, fifthNav]
        
        let firstTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        firstTabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        let secondTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "calendar.circle"), tag: 1)
        secondTabBarItem.selectedImage = UIImage(systemName: "calendar.circle.fill")
        
        let thirdTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.circle"), tag: 2)
        thirdTabBarItem.selectedImage = UIImage(systemName: "plus.circle.fill")
        
        let fourthTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person.2"), tag: 3)
        fourthTabBarItem.selectedImage = UIImage(systemName: "person.2.fill")
        
        let fifthTabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person.circle"), tag: 4)
        fifthTabBarItem.selectedImage = UIImage(systemName: "person.circle.fill")
        
        firstNav.tabBarItem = firstTabBarItem
        secondNav.tabBarItem = secondTabBarItem
        thirdNav.tabBarItem = thirdTabBarItem
        fourthNav.tabBarItem = fourthTabBarItem
        fifthNav.tabBarItem = fifthTabBarItem
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

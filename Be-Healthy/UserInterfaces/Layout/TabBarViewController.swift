//
//  TabBarViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/29.
//

import UIKit

class TabBarViewController: UITabBarController {
    var index = 0
    
    override func viewDidLoad() {
        tabBar.tintColor = UIColor.init(named: "mainColor")
        tabBar.unselectedItemTintColor = UIColor.init(named: "mainColor")
        tabBar.backgroundColor = .white
        
        setupLayout()
    }
    
    func setupLayout() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        let firstNav = HomeViewController()
        let secondNav = CalendarViewController()
        let thirdNav = UINavigationController.init(rootViewController: UIViewController())
        let fourthNav = UINavigationController.init(rootViewController: CommunityPrepareView())
        let fifthNav = UINavigationController.init(rootViewController: ProfileViewController())
        
        self.viewControllers = [firstNav, secondNav, thirdNav, fourthNav, fifthNav]
        
        let firstTabBarItem = UITabBarItem(title: "", image: UIImage(named: "home"), tag: 0)
        let secondTabBarItem = UITabBarItem(title: "", image: UIImage(named: "calendar"), tag: 1)
        let fourthTabBarItem = UITabBarItem(title: "", image: UIImage(named: "community"), tag: 3)
        let fifthTabBarItem = UITabBarItem(title: "", image: UIImage(named: "mypage"), tag: 4)
        
        firstNav.tabBarItem = firstTabBarItem
        secondNav.tabBarItem = secondTabBarItem
        fourthNav.tabBarItem = fourthTabBarItem
        fifthNav.tabBarItem = fifthTabBarItem
        
        setupMiddleButton()
    }
    
    func setupMiddleButton() {
        let middleButton = UIButton(frame: CGRect(x: (self.view.bounds.width / 2) - 35, y: -10, width: 75, height: 75))
        
        middleButton.setBackgroundImage(UIImage(named: "add"), for: .normal)
        
        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    @objc func menuButtonAction(sender: UIButton) {
        let vc = AddWorkoutViewController(idx: nil)
        vc.sheetPresentationController?.prefersGrabberVisible = true
        self.present(vc, animated: true)
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

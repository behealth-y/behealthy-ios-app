//
//  HomeViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import Then
import SnapKit

class HomeViewController: UIViewController {
    /// scrollView 변수 초기화
    lazy var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLayout()
    }
}

// MARK: - 레이아웃 설정 관련
extension HomeViewController {
    /// 네비게이션 바 설정
    fileprivate func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
//        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.init(named: "mainColor")!]
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.tintColor = UIColor.init(named: "mainColor")
        
        navigationItem.title = "BE HEALTHY"
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        view.backgroundColor = .systemPink
    }
}

#if DEBUG

import SwiftUI

// OPTION + CMD + ENTER: 미리보기 화면 띄우기, OPTION + CMD + P: 미리보기 resume
struct HomeViewControllerPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        HomeViewController()
    }
}

struct HomeViewControllerPresentable_PreviewProvider: PreviewProvider {
    static var previews: some View {
        HomeViewControllerPresentable()
    }
}

#endif




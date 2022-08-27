//
//  BHAuthViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit

class BHAuthViewController: UIViewController {
    
    // 스크롤 시 status Bar 변경하기 위해 사용하는 변수
    var isTitleView: Bool = true
    
    /// scrollView 변수 초기화
    lazy var scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    
    /// titleView 변수 초기화
    let titleView = TitleView()
    
    /// status Bar 색상 설정
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if isTitleView {
//            return .lightContent
//        } else {
//            return .default
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setNeedsStatusBarAppearanceUpdate()
//    }
}

// MARK: - 레이아웃 설정 관련
extension BHAuthViewController {
    /// 네비게이션 바 설정
    func setupNavigationBar(_ title: String) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.title = title
        navigationItem.titleView = UIView()
        
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
    }
}

// MARK: - UIScrollViewDelegate
extension BHAuthViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPos = scrollView.contentOffset.y
        
        scrollView.bounces = yPos > 100
        
        // 스크롤 시 statusBar 색 변경
        if yPos >= titleView.bounds.maxY - 200 {
            isTitleView = false
        } else {
            isTitleView = true
        }
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
}

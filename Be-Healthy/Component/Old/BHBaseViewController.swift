//
//  BHBaseViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/27.
//

import UIKit

class BHBaseViewController: UIViewController {
    
    // 스크롤 시 status Bar 변경하기 위해 사용하는 변수
    var isTitleView: Bool = true
    
    /// scrollView 변수 초기화
    lazy var scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.delegate = self
    }
    
    /// titleView 변수 초기화
    let titleView = TitleView()
    
    /// status Bar 색상 설정 (UINavigationController 아닐 때)
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
extension BHBaseViewController {
    /// 네비게이션 바 설정
    func setupNavigationBar(_ title: String) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .clear
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        appearance.backgroundColor = UIColor.init(named: "mainColor")
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationItem.title = title
        navigationItem.titleView = UIView()
        
        navigationController?.view.backgroundColor = .clear
        
        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.barStyle = .black
    }
    
    /// scrollView touchesBegan 호출 안되는 문제 해결
    func setupScrollView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.isEnabled = true
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Actions
extension BHBaseViewController {
    /// 키보드 내리기
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

// MARK: - 키보드가 textField 가리는 문제 해결
extension BHBaseViewController {
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 키보드 나타날 때 키보드 높이만큼 스크롤
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
        scrollView.contentInset = contentInset
    }
    
    /// 키보드 숨길때 키보드 높이만큼 스크롤 되었던 거 복구
    @objc func keyboardWillHide(notification: NSNotification) {
       guard let userInfo = notification.userInfo,
             let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
           return
       }
       scrollView.contentInset = .zero
   }
}

// MARK: - UIScrollViewDelegate
extension BHBaseViewController: UIScrollViewDelegate {
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

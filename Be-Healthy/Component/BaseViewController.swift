//
//  BaseViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/12/29.
//

import UIKit

class BaseViewController: UIViewController {
    /// scrollView 변수 초기화
    lazy var scrollView = UIScrollView().then {
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        setupScrollView()
        setKeyboardObserver()
    }
}

// MARK: - Extension
extension BaseViewController {
    /// 화면 터치 시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /// 화면 터치 시 키보드 내리기 > scrollView에서는 touchesBegan 호출 안되는 문제 해결
    func setupScrollView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.isEnabled = true
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    /// 키보드가 textField 가리는 문제 해결
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Actions
    
    /// 키보드 내리기
    @objc func handleTapGesture(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
//    /// 키보드 나타날 때 키보드 높이만큼 스크롤
//    @objc func keyboardWillShow(notification: NSNotification) {
//        guard let userInfo = notification.userInfo,
//              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
//            return
//        }
//        let contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.size.height, right: 0.0)
//        scrollView.contentInset = contentInset
//    }
//
//    /// 키보드 숨길때 키보드 높이만큼 스크롤 되었던 거 복구
//    @objc func keyboardWillHide(notification: NSNotification) {
//        print(#function)
//        guard let userInfo = notification.userInfo,
//              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
//            return
//        }
//
//        scrollView.contentInset = .zero
//    }
    
    /// 키보드 나타날 때 키보드 높이만큼 스크롤
    @objc func keyboardWillShow(_ notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
            })
            
        }
    }
        
    /// 키보드 숨길때 키보드 높이만큼 스크롤 되었던 거 복구
    @objc func keyboardWillHide(_ notification: NSNotification){
        self.scrollView.transform = .identity
    }
}

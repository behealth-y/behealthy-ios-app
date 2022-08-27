//
//  UIViewController+Extension.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/26.
//

import UIKit

extension UIViewController {
    /// 키보드 나타나고 / 숨겨질 때 텍스트필드 가려지지 않도록 처리
    /// 참고: https://fomaios.tistory.com/entry/iOS-%ED%82%A4%EB%B3%B4%EB%93%9C%EA%B0%80-%ED%85%8D%EC%8A%A4%ED%8A%B8%ED%95%84%EB%93%9C%EB%A5%BC-%EA%B0%80%EB%A6%B4%EB%95%8C-%ED%95%B4%EA%B2%B0%EB%B2%95When-the-keyboard-covers-text-field
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// 키보드 나타날 때 키보드 높이만큼 스크롤
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let titleViewHeight = self.view.frame.width / 1.79
            UIView.animate(withDuration: 1) {
                guard let yPos = self.view.window?.frame.origin.y else { return }
                if yPos >= 0 {
                    self.view.window?.frame.origin.y -= titleViewHeight
                }
            }
        }
    }
    
    /// 키보드 숨길때 키보드 높이만큼 스크롤 되었던 거 복구
    @objc func keyboardWillHide(notification: NSNotification) {
       if self.view.window?.frame.origin.y != 0 {
           if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardRectangle = keyboardFrame.cgRectValue
                    let keyboardHeight = keyboardRectangle.height
                    let titleViewHeight = self.view.frame.width / 1.79
                    UIView.animate(withDuration: 1) {
                        self.view.window?.frame.origin.y += titleViewHeight
                    }
           }
       }
   }
}

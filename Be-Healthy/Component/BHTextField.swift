//
//  BHTextField.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import SnapKit

class BHTextField: UITextField {
    var parameterName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        self.font = .systemFont(ofSize: 14.0)
        self.textColor = .black
        self.addLeftPadding()
        
        self.enablesReturnKeyAutomatically = true // 값 입력 시 리턴 키 활성화
        self.autocorrectionType = .no // 자동 완성
        self.autocapitalizationType = .none // 첫 글자 대문자
    }
}

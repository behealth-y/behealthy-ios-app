//
//  BHTextField.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import SnapKit

class BHTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    fileprivate func setupLayout() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        self.font = .systemFont(ofSize: 14.0)
        self.placeholder = "아이디를 입력하세요."
        self.addLeftPadding()
    }
}

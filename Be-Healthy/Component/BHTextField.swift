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
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        
        self.addLeftPadding()
    }
}

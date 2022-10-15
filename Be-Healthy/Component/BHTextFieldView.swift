//
//  BHTextFieldView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/09.
//

import UIKit
import SnapKit

class BHTextFieldView: UIView {
    let textField = BHTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(parameterName: String, placeholder: String, keyboardType: UIKeyboardType = .default, secure: Bool = false) {
        self.init(frame: .zero)
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = secure
        textField.parameterName = parameterName
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        self.addSubview(textField)
        
        // textField 높이
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let bottomBorder = UIView().then {
            $0.backgroundColor = UIColor.init(hexFromString: "B0B0B0")
        }
        
        self.addSubview(bottomBorder)
        
        bottomBorder.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
}

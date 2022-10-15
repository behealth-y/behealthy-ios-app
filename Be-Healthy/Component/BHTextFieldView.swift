//
//  BHTextFieldView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/09.
//

import UIKit
import SnapKit

class BHTextFieldView: UIView {
    var inputTextField: BHTextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(textField: BHTextField) {
        self.init(frame: .zero)
        inputTextField = textField
        
        setupLayout()
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        guard let inputTextField = inputTextField else { return }
        
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        
        self.addSubview(inputTextField)
        
        // textField 높이
        inputTextField.snp.makeConstraints {
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

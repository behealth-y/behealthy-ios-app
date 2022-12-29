//
//  BHSubmitButton.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/26.
//

import UIKit
import SnapKit

class BHSubmitButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .init(named: "mainColor")
            } else {
                self.backgroundColor = .init(hexFromString: "#A9A9A9")
            }
        }
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = UIColor.init(named: "mainColor")
        self.titleLabel?.font = .systemFont(ofSize: 16.0)
        self.layer.cornerRadius = 5.0
        
        self.snp.makeConstraints {
            $0.height.equalTo(55)
        }
    }
}


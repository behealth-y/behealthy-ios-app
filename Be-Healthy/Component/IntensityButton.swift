//
//  IntensityButton.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/02.
//

import UIKit
import SnapKit
import Then

class IntensityButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(title: String, tag: Int) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.tag = tag
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
//        var config = UIButton.Configuration.tinted()
//        config.buttonSize = .mini
//        config.baseBackgroundColor = .clear
//        config.baseForegroundColor = UIColor.init(named: "mainColor")
//
//        self.configuration = config
        
        self.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        self.setTitleColor(UIColor.init(hexFromString: "#2E2E2E"), for: .normal)
        self.setTitleColor(.white, for: .selected)
        self.titleLabel?.font = .boldSystemFont(ofSize: 12)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.init(hexFromString: "#2E2E2E").cgColor
        self.layer.cornerRadius = 5
    }
}

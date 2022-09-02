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
    
    convenience init(title: String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        var config = UIButton.Configuration.plain()
        config.buttonSize = .mini
        
        self.configuration = config
        self.setTitleColor(UIColor.init(named: "mainColor"), for: .normal)
        self.titleLabel?.font = .boldSystemFont(ofSize: 11)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.init(named: "mainColor")?.cgColor
        self.layer.cornerRadius = 10
    }
}

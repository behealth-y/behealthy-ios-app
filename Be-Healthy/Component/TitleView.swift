//
//  TitleView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/25.
//

import UIKit
import Then
import SnapKit

class TitleView: UIView {
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// 레이아웃 설정
    fileprivate func setupLayout() {
        self.backgroundColor = UIColor.init(named: "mainColor")
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 35, weight: .bold)
        
        self.addSubview(titleLabel)
        
        // titleView > label 위치 잡기
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(18)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

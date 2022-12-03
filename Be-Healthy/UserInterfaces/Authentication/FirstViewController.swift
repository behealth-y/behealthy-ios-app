//
//  FirstViewController.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/12/03.
//

import UIKit
import SnapKit
import Then

class FirstViewController: UIViewController {
    private let logoLabel = UILabel().then {
        $0.text = "BE HEALTHY"
        $0.textColor = UIColor(named: "mainColor")
        $0.font = .systemFont(ofSize: 50, weight: .init(900))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
}

// MARK: - 레이아웃 관련
extension FirstViewController {
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(logoLabel)
        
        logoLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
    }
}

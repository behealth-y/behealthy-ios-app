//
//  CommunityPrepareView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import UIKit
import SnapKit
import Then

final class CommunityPrepareView: BaseViewController {
    private let label = UILabel().then {
        $0.text = "준비중입니다. :)"
        $0.font = .boldSystemFont(ofSize: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

// MARK: - Extensions
extension CommunityPrepareView {
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

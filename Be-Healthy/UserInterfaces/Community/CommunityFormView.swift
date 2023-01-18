//
//  CommunityFormView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/15.
//

import UIKit
import SnapKit
import Then

final class CommunityFormView: BaseViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}

// MARK: - Extensions
extension CommunityFormView {
    // MARK: View
    private func setupViews() {
        view.backgroundColor = .white
    }
}


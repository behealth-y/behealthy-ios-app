//
//  CommunityDetailView.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/15.
//

import UIKit
import SnapKit
import Then

final class CommunityDetailView: BaseViewController {
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
    }
}

// MARK: - Extensions
extension CommunityDetailView {
    // MARK: View
    private func setupNavigationBar() {
        navigationItem.title = "#오운완"
    }
    
    private func setupViews() {
        view.backgroundColor = .white
    }
}

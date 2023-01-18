//
//  CommunityCell.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/15.
//

import UIKit
import SnapKit
import Then

final class CommunityCell: UICollectionViewCell {
    static let identifier = "CommunityCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extension
extension CommunityCell {
    // MARK: View
    private func setupCell() {
        self.backgroundColor = .systemOrange
        
        self.layer.cornerRadius = 10
    }
}

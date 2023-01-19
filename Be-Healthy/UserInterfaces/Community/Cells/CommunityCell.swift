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
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        
        $0.layer.cornerRadius = 10
    }
    
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
        self.backgroundColor = .clear
        
//        self.layer.cornerRadius = 10
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateUI(image: UIImage) {
        imageView.image = image
    }
}

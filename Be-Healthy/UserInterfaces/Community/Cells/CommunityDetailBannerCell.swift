//
//  CommunityDetailBannerCell.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/19.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class CommunityDetailBannerCell: UICollectionViewCell {
    static let identifier = "CommunityDetailBannerCell"
    
    lazy var imageView = UIImageView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommunityDetailBannerCell {
    private func setupCell() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func updateUI() {
//        let imageUrl = URL(string: bannerImg)!
//        imageView.kf.indicatorType = .activity
//        imageView.kf.setImage(with: imageUrl)
        imageView.image = UIImage(named: "bannerImg")
    }
}

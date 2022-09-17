//
//  TopThreeCollectionViewCell.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/17.
//

import UIKit

class TopThreeCollectionViewCell: UICollectionViewCell {
    static let identifier = "TopThreeCollectionViewCell"
    
    @IBOutlet weak var topThreeView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
}

extension TopThreeCollectionViewCell {
    fileprivate func setupLayout() {
        topThreeView.layer.cornerRadius = 10
        topThreeView.layer.masksToBounds = false
        topThreeView.layer.shadowColor = UIColor.black.cgColor
        topThreeView.layer.shadowOffset = CGSize(width: 4, height: 4)
        topThreeView.layer.shadowOpacity = 0.25
        topThreeView.layer.shadowRadius = 5.0
    }
}

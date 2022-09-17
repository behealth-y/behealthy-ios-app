//
//  RecordListCollectionViewCell.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/17.
//

import UIKit

class RecordListCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecordListCollectionViewCell"
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var bottomBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
}

extension RecordListCollectionViewCell {
    fileprivate func setupLayout() {
//        emojiLabel.layer.borderWidth = 0.3
//        emojiLabel.layer.borderColor = UIColor.init(hexFromString: "B0B0B0").cgColor
//        emojiLabel.layer.cornerRadius = emojiLabel.frame.width / 2
        
        bottomBorder.backgroundColor = UIColor.init(hexFromString: "B0B0B0")
    }
}

//
//  RecordListCollectionViewCell.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/17.
//

import UIKit

protocol RecordListCollectionViewCellDelegate: NSObject {
    func showMoreMenu()
}

class RecordListCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecordListCollectionViewCell"
    
    weak var delegate: RecordListCollectionViewCellDelegate?
     
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var workOutNameLabel: UILabel!
    @IBOutlet weak var workOutTimeLabel: UILabel!
    @IBOutlet weak var bottomBorder: UIView!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    // MARK: - Actions
    
    /// 더 보기 버튼 클릭 시 편집 / 삭제 선택 메뉴 노출
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        delegate?.showMoreMenu()
    }
}

extension RecordListCollectionViewCell {
    // 레이아웃 설정
    fileprivate func setupLayout() {
//        emojiLabel.layer.borderWidth = 0.3
//        emojiLabel.layer.borderColor = UIColor.init(hexFromString: "B0B0B0").cgColor
//        emojiLabel.layer.cornerRadius = emojiLabel.frame.width / 2
        
        emojiLabel.text = ""
        workOutTimeLabel.text = ""
        workOutTimeLabel.text = ""
        
        bottomBorder.backgroundColor = .border
    }
    
    func updateUI(data: WorkOutRecord?) {
        guard let data = data else { return }
        
        emojiLabel.text = data.emoji
        workOutNameLabel.text = data.workOutName
        workOutTimeLabel.text = "\(data.workOutTime)분"
    }
}

//
//  RecordListCollectionViewCell.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/17.
//

import UIKit

protocol RecordListCollectionViewCellDelegate: NSObject {
    func showMoreMenu()
    func updateConstraints()
}

class RecordListCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecordListCollectionViewCell"
    
    weak var delegate: RecordListCollectionViewCellDelegate?
     
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var WorkoutNameLabel: UILabel!
    @IBOutlet weak var WorkoutTimeLabel: UILabel!
    @IBOutlet weak var bottomBorder: UIView!
    @IBOutlet weak var moreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func layoutSubviews() {
        delegate?.updateConstraints()
    }
}

// MARK: - Extension
extension RecordListCollectionViewCell {
    // 레이아웃 설정
    fileprivate func setupCell() {
//        emojiLabel.layer.borderWidth = 0.3
//        emojiLabel.layer.borderColor = UIColor.init(hexFromString: "B0B0B0").cgColor
//        emojiLabel.layer.cornerRadius = emojiLabel.frame.width / 2
        
        emojiLabel.text = ""
        WorkoutTimeLabel.text = ""
        WorkoutTimeLabel.text = ""
        
        bottomBorder.backgroundColor = .border
    }
    
    func updateUI(data: WorkoutRecordForDate?) {
        guard let data = data else { return }
        
        emojiLabel.text = data.emoji
        WorkoutNameLabel.text = data.workoutName
        WorkoutTimeLabel.text = "60분"
    }
    
    // MARK: Actions
    /// 더 보기 버튼 클릭 시 편집 / 삭제 선택 메뉴 노출
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        delegate?.showMoreMenu()
    }
}

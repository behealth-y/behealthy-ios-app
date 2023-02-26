//
//  RecordListCollectionViewCell.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/17.
//

import UIKit

protocol RecordListCollectionViewCellDelegate: NSObject {
    func showMoreMenu(_ idx: Int)
    func updateConstraints()
}

class RecordListCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecordListCollectionViewCell"
    
    weak var delegate: RecordListCollectionViewCellDelegate?
    
    private var idx: Int?
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var workoutTimeLabel: UILabel!
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
        workoutTimeLabel.text = ""
        workoutTimeLabel.text = ""
        
        bottomBorder.backgroundColor = .border
    }
    
    func updateUI(data: WorkoutRecordForDate?) {
        guard let data = data else { return }
        
        let workoutTime = data.workoutTime ?? 0
        
        idx = data.idx
        emojiLabel.text = data.emoji
        workoutNameLabel.text = data.workoutName
        workoutTimeLabel.text = "\(workoutTime)분"
    }
    
    // MARK: Actions
    /// 더 보기 버튼 클릭 시 편집 / 삭제 선택 메뉴 노출
    @IBAction func didTapMoreButton(_ sender: UIButton) {
        guard let idx = idx else { return }
        delegate?.showMoreMenu(idx)
    }
}

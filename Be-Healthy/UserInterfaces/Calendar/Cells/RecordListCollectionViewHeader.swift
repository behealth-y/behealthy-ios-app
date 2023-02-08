//
//  RecordListCollectionViewHeader.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/09/17.
//

import UIKit

class RecordListCollectionViewHeader: UICollectionReusableView {
    static let identifier = "RecordListCollectionViewHeader"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
        timeLabel.text = ""
    }
    
    func updateUI(date: String, time: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let currentDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "MM월 dd일"
        let dateString = dateFormatter.string(from: currentDate!)
        
        titleLabel.text = "\(dateString) 운동 기록"
        timeLabel.text = "총 \(time.minuteToTime())"
    }
}

//
//  Int+Extension.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/08.
//

import Foundation

extension Int {
    /// 분 -> n시간 n분 변환
    func minuteToTime() -> (String) {
        let (h,m) = (self / 60, self % 60)

        return "\(h)시간 \(m)분"
    }
}

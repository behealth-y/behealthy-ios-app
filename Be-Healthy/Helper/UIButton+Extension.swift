//
//  UIButton+Extension.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/26.
//

import UIKit

extension UIButton {
    /// 밑줄 추가
    func addUnderLine() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: title.count))
        setAttributedTitle(attributedString, for: .normal)
    }
}

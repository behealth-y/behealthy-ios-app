//
//  UIImage+Extension.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/08/26.
//

import UIKit

extension UIImage {
    /// UIImage 사이즈 재설정
    /// - Parameter size: 재설정할 사이즈
    /// - Returns: 사이즈가 재설정된 이미지
    func resizeImageTo(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

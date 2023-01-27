//
//  ErrorData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation

// MARK: - ErrorData
struct ErrorData: Codable {
    let errorCode, reason: String?
}

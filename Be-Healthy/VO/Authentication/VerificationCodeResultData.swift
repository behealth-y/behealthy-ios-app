//
//  VerificationCodeResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/26.
//

import Foundation

struct RequestVerificationCodeResultData {
    let statusCode: Int?
    let result: RequestVerificationCodeResult?
}

// MARK: - RequestVerificationCodeResult
struct RequestVerificationCodeResult: Codable {
    let expireAt: String?
    let errorCode, reason: String?
}

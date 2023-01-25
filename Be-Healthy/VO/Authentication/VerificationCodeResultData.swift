//
//  VerificationCodeResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/26.
//

import Foundation

// MARK: - RequestVerificationCodeResultData
struct RequestVerificationCodeResultData: Codable {
    let expireAt: String?
    let errorCode, reason: String?
}

// MARK: - VerifyCodeResultData
struct VerifyCodeResultData: Codable {
    let errorCode, reason: String?
}

//
//  VerificationCodeResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/26.
//

import Foundation

struct RequestVerificationCodeResult {
    let statusCode: Int?
    let result: RequestVerificationCodeResultData?
}

struct RequestVerificationCodeResultData: Codable {
    let expireAt: String?
    let errorCode, reason: String?
}

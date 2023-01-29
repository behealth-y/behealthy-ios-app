//
//  ResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation

// MARK: - ResultData
struct ResultData: Codable {
    let errorCode, reason: String?
}

struct Result {
    let statusCode: Int?
    let errorData: ResultData?
}

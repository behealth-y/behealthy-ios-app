//
//  WorkOutGoalResusltData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation

struct WorkOutGoalResultData {
    let statusCode: Int?
    let result: WorkOutGoalResult?
}

// MARK: - WorkOutGoalResult
struct WorkOutGoalResult: Codable {
    let hour, minute: Int?
    let errorCode, reason: String?
}

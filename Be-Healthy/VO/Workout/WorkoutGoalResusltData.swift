//
//  WorkoutGoalResusltData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation

struct WorkoutGoalResultData {
    let statusCode: Int?
    let result: WorkoutGoalResult?
}

// MARK: - WorkoutGoalResult
struct WorkoutGoalResult: Codable {
    let hour, minute: Int?
    let errorCode, reason: String?
}

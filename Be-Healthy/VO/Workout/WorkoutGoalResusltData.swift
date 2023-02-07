//
//  WorkoutGoalResusltData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation

struct WorkoutGoalResult {
    let statusCode: Int?
    let result: WorkoutGoalResultData?
}

struct WorkoutGoalResultData: Codable {
    let hour, minute: Int?
    let errorCode, reason: String?
}

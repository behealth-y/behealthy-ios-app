//
//  WorkoutRecordsResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/07.
//

import Foundation

// MARK: - 운동 시간 기록 추가
struct AddWorkoutRecordResult: Codable {
    let statusCode: Int?
    let result: AddWorkoutRecordResultData
}

struct AddWorkoutRecordResultData: Codable {
    let id: Int?
    let errorCode, reason: String?
}

// MARK: - 특정 년/월 기준 운동 시간 기록
struct WorkoutTimesResult: Codable {
    let statusCode: Int?
    let result: WorkoutTimesResultData
}

struct WorkoutTimesResultData: Codable {
    let year: Int?
    let month: Int?
    let workoutLogs: [WorkoutTimeLog]?
    let errorCode, reason: String?
}

struct WorkoutTimeLog: Codable {
    let date: String
    let totalWorkoutTime: Int
}

// MARK: - 특정 날짜 기준 운동 기록
struct WorkoutRecordsResult: Codable {
    let statusCode: Int?
    let result: WorkoutRecordsResultData
}

struct WorkoutRecordsResultData: Codable {
    let date: String?
    let totalWorkoutTime: Int?
    let workoutLogs: [WorkoutLog]?
    let errorCode, reason: String?
}

struct WorkoutLog: Codable {
    let workoutLogId: Int
    let name: String
    let emoji: String
    let workoutTime: Int
}

// MARK: - 특정 idx 기준 운동 기록
struct WorkoutRecordResult: Codable {
    let statusCode: Int?
    let result: WorkoutRecordResultData
}

struct WorkoutRecordResultData: Codable {
    let workoutLogId: Int
    let name: String
    let date: String?
    let emoji: String
    let startTime: String?
    let endTime: String?
    let intensity: String?
    let comment: String?
    let errorCode, reason: String?
}

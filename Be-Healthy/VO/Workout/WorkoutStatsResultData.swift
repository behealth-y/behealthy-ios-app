//
//  WorkoutStatsResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/19.
//

import Foundation

struct WorkoutStatsResult {
    let statusCode: Int?
    let result: WorkoutStatsResultData?
}

/*
 {
     "workoutGoal": {
         "hour": 1,
         "minute": 0
     },
     "todayWorkoutTime": 0,
     "avgWorkoutTimeInCurrentWeek": 50,
     "workoutTimesInCurrentWeek": [
         {
             "date": "2023-02-13",
             "workoutTime": 50
         }
     ]
 }
 */
struct WorkoutStatsResultData: Codable {
    let workoutGoal: WorkoutGoal
    let todayWorkoutTime: Int
    let avgWorkoutTimeInCurrentWeek: Float
    let workoutTimesInCurrentWeek: [WorkoutTimesIntCurrentWeek]
    let errorCode, reason: String?
}

struct WorkoutGoal: Codable {
    let hour: Int
    let minute: Int
}

struct WorkoutTimesIntCurrentWeek: Codable {
    let date: String
    let workoutTime: Int
}

//
//  WorkOutRecord.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/29.
//

import UIKit

struct WorkoutRecord {
    let date: String
    let workOutRecords: [WorkoutRecordForDate]
    var callAPI: Bool
}

struct WorkoutRecordForDate {
    let idx: Int?
    let emoji: String
    let workoutName: String
    let intensity: String
    let comment: String
    let startTime: String
    var endTime: String
    
    init(emoji: String, workoutName: String, startTime: String, endTime: String, intensity: String, comment: String) {
        self.idx = nil
        self.emoji = emoji
        self.workoutName = workoutName
        self.startTime = startTime
        self.endTime = endTime
        self.intensity = intensity
        self.comment = comment
    }
}

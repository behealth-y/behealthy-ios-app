//
//  WorkOutRecord.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/29.
//

import UIKit

struct WorkoutRecord {
    var workOutRecords: [WorkoutRecordForDate]
    var totalWorkoutTime: Int
    var callAPI: Bool
    
    mutating func add(record: WorkoutRecordForDate) {
        workOutRecords.append(record)
    }
    
    mutating func update(record: WorkoutRecordForDate) {
        let idx = workOutRecords.enumerated().filter({ $0.element.idx == record.idx }).map({ $0.offset })[0]
        
        workOutRecords[idx] = record
    }
    
    mutating func delete(idx: Int) {
        let idx = workOutRecords.enumerated().filter({ $0.element.idx == idx }).map({ $0.offset })[0]
        
        workOutRecords.remove(at: idx)
    }
}

struct WorkoutRecordForDate {
    let idx: Int?
    var emoji: String
    var workoutName: String
    var intensity: String?
    var comment: String?
    var startTime: String?
    var endTime: String?
    var workoutTime: Int?
    
    init(emoji: String, workoutName: String, startTime: String, endTime: String, intensity: String, comment: String, workoutTime: Int) {
        self.idx = nil
        self.emoji = emoji
        self.workoutName = workoutName
        self.startTime = startTime
        self.endTime = endTime
        self.intensity = intensity
        self.comment = comment
        self.workoutTime = workoutTime
    }
    
    init(workoutLogId: Int, emoji: String, workoutName: String, workoutTime: Int) {
        self.idx = workoutLogId
        self.emoji = emoji
        self.workoutName = workoutName
        self.workoutTime = workoutTime
    }
}

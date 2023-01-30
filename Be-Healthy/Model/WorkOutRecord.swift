//
//  WorkOutRecord.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/29.
//

import UIKit

struct WorkOutRecord {
    let idx: Int
    let emoji: String
    let workOutName: String
    let date: String
    let startTime: WorkOutTime
    let endTime: WorkOutTime
    let intensity: String
    let comment: String
}

struct WorkOutTime {
    let hour: Int
    let minute: Int
}

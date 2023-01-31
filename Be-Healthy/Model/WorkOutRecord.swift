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
    let startTime: String
    let endTime: String
    let intensity: String
    let comment: String
    
    func getStartTime() -> String {
        return startTime + ":00"
    }
    
    func getEndTime() -> String {
        return endTime + ":00"
    }
}

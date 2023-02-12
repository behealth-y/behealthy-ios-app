//
//  RecordsRepository.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/05.
//

import Foundation
import Combine

final class RecordsRepository {
    static let shared = RecordsRepository()
    
    @Published var records: [String: WorkoutRecord]
    private var cancellables: Set<AnyCancellable> = .init()
    
    /// 운동 기록 조회 (특정 날짜)
    func get(for date: String) -> WorkoutRecord? {
        return records[date]
    }
    
    /// 운동 기록 조회 (특정 날짜의 특정 행)
    func get(for date: String, at: Int) -> WorkoutRecordForDate? {
        return records[date]?.workOutRecords[at]
    }
    
    init() {
        self.records = [:]
    }
    
    func setCallAPI(date: String, yn: Bool) {
        if let _ = records[date] {
            records[date]?.callAPI = yn
        } else {
            records[date] = WorkoutRecord(workOutRecords: [], totalWorkoutTime: 0, callAPI: true)
        }
    }
    
    func setWorkoutTime(date: String, time: Int = 0) {
        if let record = records[date] {
            let time = record.workOutRecords.flatMap({ $0.workoutTime }).reduce(0) { $0 + $1 }
            records[date]?.totalWorkoutTime = time
        } else {
            records[date] = WorkoutRecord(workOutRecords: [], totalWorkoutTime: time, callAPI: false)
        }
    }
    
    func addWorkoutRecord(date: String, record: WorkoutRecordForDate) {
        if let _ = records[date] {
            records[date]?.add(record: record)
        } else {
            records[date] = WorkoutRecord(workOutRecords: [record], totalWorkoutTime: record.workoutTime ?? 0, callAPI: false)
        }
    }
    
    func updateWorkoutRecord(date: String, logDate: String?, record: WorkoutRecordForDate) {
        guard let logDate = logDate, let idx = record.idx else { return }
        
        if date != logDate {
            self.records[logDate]?.delete(idx: idx)
            self.addWorkoutRecord(date: date, record: record)
        } else {
            self.records[date]?.update(idx: idx, record: record)
        }
    }
    
    func deleteWorkoutRecord(date: String, idx: Int) {
        self.records[date]?.delete(idx: idx)
    }
}

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
        // TODO: 운동 기록 없을 때 API로 조회 및 값 저장
        return records[date]
    }
    
    /// 운동 기록 조회 (특정 날짜의 특정 행)
    func get(for date: String, at: Int) -> [WorkoutRecordForDate]? {
        return records[date]?.workOutRecords
    }
    
    init() {
        self.records = [:]
    }
    
    func addWorkoutRecord(date: String, record: WorkoutRecordForDate) {
        self.records[date]?.add(record: record)
    }
}

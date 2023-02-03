//
//  WorkoutRecordViewModel.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/29.
//

/*
    날짜별 운동 기록 조회
    - 처음에는 오늘 날짜만, 다음엔 선택한 날짜 API로 조회 (앱 켰다 키면 초기화)
    - 이미 저장되어 있는 날짜는 기존에 있는 데이터 사용
 
    날짜별 운동 기록 추가 & 수정 & 삭제
    - API response 성공 시에만 값 저장 및 ui 변경
 */

import Foundation
import Combine

// MARK: - 운동 기록 내역 (전체)
class WorkoutRecordViewModel {
    private let service = WorkoutService()
    
    private var records: [WorkoutRecord]
    
    init(records: [WorkoutRecord]) {
        self.records = records
    }
    
    /// 운동 기록 조회 (특정 날짜)
    func get(for date: String) -> [WorkoutRecord] {
        // TODO: 운동 기록 없을 때 API로 조회 및 값 저장
        return records.filter({ $0.date == date })
    }
    
    /// 운동 기록 조회 (특정 날짜의 특정 행)
    func get(for date: String, at: Int) -> [WorkoutRecordForDate] {
        return records.filter({ $0.date == date }).map({ $0.workOutRecords[at] })
    }
    
    /// 운동 기록 추가
    func insert(for date: String, workout: WorkoutRecordForDate) {
        service.addWorkoutRecord(date: date, workout: workout) { data in
            print(data)
        }
    }
    
    func update(_ idx: Int, workout: WorkoutService) {
        
    }
    
    /// 운동 기록 삭제
    func delete(_ idx: Int) {
        
    }
}

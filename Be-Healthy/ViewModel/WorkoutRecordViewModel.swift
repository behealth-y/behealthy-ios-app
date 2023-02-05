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

protocol WorkoutRecordViewModelDelegate: NSObject {
    func addWorkoutRecordSuccess()
    func addWorkoutRecordFail()
}

// MARK: - 운동 기록 내역 (전체)
class WorkoutRecordViewModel {
    weak var delegate: WorkoutRecordViewModelDelegate?
    
    private let service = WorkoutService()
    
    private let repository = RecordsRepository.shared
    
    init() {
        
    }
    
    /// 운동 기록 추가
    func insert(for date: String, record: WorkoutRecordForDate) {
        service.addWorkoutRecord(date: date, record: record) { [weak self] data in
            if let statusCode = data.statusCode {
                switch statusCode {
                case 200:
                    if self?.repository.records[date] != nil {
                        self?.repository.addWorkoutRecord(date: date, record: record)
                    } else {
                        self?.repository.records[date] = WorkoutRecord(workOutRecords: [record], callAPI: true)
                    }
                    
                    self?.delegate?.addWorkoutRecordSuccess()
                default:
                    guard let errorData = data.errorData else { return }
                    print(errorData)
                    self?.delegate?.addWorkoutRecordFail()
                }
            }
        }
    }
    
    func update(_ idx: Int, record: WorkoutService) {
        
    }
    
    /// 운동 기록 삭제
    func delete(_ idx: Int) {
        
    }
}

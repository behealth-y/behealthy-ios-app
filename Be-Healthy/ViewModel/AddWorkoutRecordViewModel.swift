//
//  AddWorkoutRecordViewModel.swift
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

protocol AddWorkoutRecordViewModelDelegate: NSObject {
    func addWorkoutRecordSuccess()
    func addWorkoutRecordFail()
    func updateWorkoutRecordSuccess()
    func updateWorkoutRecordFail()
}

// MARK: - 운동 기록 내역 (전체)
class AddWorkoutRecordViewModel {
    weak var delegate: AddWorkoutRecordViewModelDelegate?
    
    private let service = WorkoutService()
    
    private let repository = RecordsRepository.shared
    
    init() { }
    
    /// 운동 기록 추가
    func insert(for date: String, record: WorkoutRecordForDate) {
        service.addWorkoutRecord(date: date, record: record) { [weak self] data in
            if let statusCode = data.statusCode {
                switch statusCode {
                case 200:
                    guard let idx = data.result.id else { return }
                    
                    // TODO: 운동 기록 추가 시 받아온 idx값을 저장하는 더 좋은 방법 고민 필요
                    var record = record
                    record.idx = idx
                    
                    self?.repository.addWorkoutRecord(date: date, record: record)
                    
                    if let recordForDate = self?.repository.records[date] {
                        let workoutTime = record.workoutTime ?? 0
                        
                        self?.repository.setWorkoutTime(date: date, time: recordForDate.totalWorkoutTime + workoutTime)
                    }
                    
                    self?.delegate?.addWorkoutRecordSuccess()
                default:
                    guard let errorCode = data.result.errorCode, let reason = data.result.reason else { return }
                    print(errorCode)
                    print(reason)
                    self?.delegate?.addWorkoutRecordFail()
                }
            }
        }
    }
    
    func update(for date: String, idx: Int, record: WorkoutRecordForDate) {
        service.updateWorkoutRecord(date: date, record: record) { [weak self] data in
            if let statusCode = data.statusCode {
                switch statusCode {
                case 200:
                    self?.repository.updateWorkoutRecord(date: date, record: record)
                    
                    self?.delegate?.updateWorkoutRecordSuccess()
                default:
                    guard let errorData = data.errorData else { return }
                    print(errorData)
                    self?.delegate?.updateWorkoutRecordFail()
                }
            }
        }
    }
}

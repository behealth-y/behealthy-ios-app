//
//  CalendarViewModel.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/05.
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

protocol CalendarViewModelDelegate: NSObject {
    func deleteWorkoutRecordSuccess()
    func deleteWorkoutRecordFail()
    func getForYearAndMonthSuccess()
    func getForYearAndMonthFail()
    func getForDateSuccess(date: String)
    func getForDateFail()
}

class CalendarViewModel {
    weak var delegate: CalendarViewModelDelegate?
    
    private let service = WorkoutService()
    
    private let repository = RecordsRepository.shared
    
    init() { }
    
    /// 운동 기록 삭제
    func delete(for date: String, idx: Int) {
        service.deleteWorkoutRecord(idx) { [weak self] data in
            if let statusCode = data.statusCode {
                switch statusCode {
                case 200:
                    self?.repository.deleteWorkoutRecord(date: date, idx: idx)
                    self?.repository.setWorkoutTime(date: date)
                    self?.delegate?.deleteWorkoutRecordSuccess()
                default:
                    guard let errorData = data.errorData else { return }
                    print(errorData)
                    self?.delegate?.deleteWorkoutRecordFail()
                }
            }
        }
    }
    
    /// 특정 년/월 기준 날짜별 운동 시간 조회
    func get(year: Int, month: Int) {
        service.getWorkoutRecords(year: year, month: month) { [weak self] data in
            if let statusCode = data.statusCode {
                switch statusCode {
                case 200:
                    guard let records = data.result.workoutLogs else { return }
                    
                    records.forEach {
                        self?.repository.setWorkoutTime(date: $0.date, time: $0.totalWorkoutTime)
                    }
                    
                    self?.delegate?.getForYearAndMonthSuccess()
                default:
                    guard let errorCode = data.result.errorCode, let reason = data.result.reason else { return }
                    print(errorCode)
                    print(reason)
                    self?.delegate?.getForYearAndMonthFail()
                }
            }
        }
    }
    
    // TODO: 시간순 정렬 (현재 idx 오름차순 정렬)
    /// 특정 날짜 기준 운동 기록 조회
    func get(date: String) {
        let record = repository.records[date]
        
        if record == nil || (record != nil && !record!.callAPI) {
            print("API 호출")
            service.getWorkoutRecords(date: date) { [weak self] data in
                if let statusCode = data.statusCode {
                    switch statusCode {
                    case 200:
                        guard let records = data.result.workoutLogs else { return }
                        print("ASDSDFASDFSADFSADFADSF asdasdasd ::: \(records)")
                        
                        print(records)
                        records.forEach {
                            let record = WorkoutRecordForDate(
                                workoutLogId: $0.workoutLogId,
                                emoji: $0.emoji,
                                workoutName: $0.name,
                                workoutTime: $0.workoutTime)
                            
                            print(record)
                            
                            self?.repository.addWorkoutRecord(date: date, record: record)
                        }
                        
                        self?.repository.setCallAPI(date: date, yn: true)
                        self?.repository.setWorkoutTime(date: date)
                        self?.delegate?.getForDateSuccess(date: date)
                    default:
                        guard let errorCode = data.result.errorCode, let reason = data.result.reason else { return }
                        print(errorCode)
                        print(reason)
                        self?.delegate?.getForDateFail()
                    }
                }
            }
        } else {
            print("API 호출 안함")
            guard let record = repository.records[date] else { return }
            self.repository.setWorkoutTime(date: date)
            self.delegate?.getForDateSuccess(date: date)
        }
    }
}

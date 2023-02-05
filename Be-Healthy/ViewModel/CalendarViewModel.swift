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

class CalendarViewModel {
    private let service = WorkoutService()
    
    private let repository = RecordsRepository.shared
    
    init() { }
    
    /// 운동 기록 삭제
    func delete(_ idx: Int) {
        
    }
}

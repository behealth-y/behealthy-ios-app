//
//  WorkOutRecordViewModel.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/29.
//

import Foundation

class WorkOutRecordViewModel {
    static let shared = WorkOutRecordViewModel()
    
    private var workOutRecordData: [WorkOutRecord] = [] {
        didSet {
            self.bindWorkOutRecordViewModelToController()
        }
    }
    
    var bindWorkOutRecordViewModelToController: (() -> Void) = {}
    
    // 값 추가
    func insert(_ data: WorkOutRecord) {
        workOutRecordData.append(data)
    }
    
    // 모든 값 읽기
    func getAll() -> [WorkOutRecord] {
        return workOutRecordData
    }
    
    // 특정 인덱스 값 읽기 (없으면 nil)
    func get(_ at: Int) -> WorkOutRecord? {
        return workOutRecordData[at]
    }
    
    // 값 삭제
    func remove(_ at: Int) {
        workOutRecordData.remove(at: at)
    }
}


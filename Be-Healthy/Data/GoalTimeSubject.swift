//
//  GoalTimeSubject.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/11.
//

import Foundation
import Combine

final class GoalTimeSubject {
    static let shared = GoalTimeSubject()
    
    @Published var goalTime: Int
    
    func setGoalTime(_ time: Int) {
        goalTime = time
        
        UserDefaults.standard.set(time, forKey: "goalTime")
    }
    
    init() {
        self.goalTime = UserDefaults.standard.integer(forKey: "goalTime")
    }
}

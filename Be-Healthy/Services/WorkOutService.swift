//
//  WorkOutService.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation
import Alamofire

final class WorkOutService {
    // MARK: 목표 운동시간 설정
    /// 목표 운동 시간 설정
    func setWorkOutGoal(hour: Int, minute: Int, completion: @escaping (Result) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt") else { return }
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-goal")!
        
        let params = [
            "hour": hour,
            "minute": minute
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ResultData.self) { response in
                if let data = response.value {
                    completion(Result(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(Result(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    /// 목표 운동 시간 조회
    func getWorkOutGoal(completion: @escaping (WorkOutGoalResultData) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt") else { return }
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-goal")!

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: WorkOutGoalResult.self) { response in
                switch response.result {
                case .success:
                    guard let result = response.value else { return }
                    
                    let data = WorkOutGoalResultData(
                        statusCode: response.response?.statusCode,
                        result: result)
                    
                    completion(data)
                    
                case let .failure(error):
                    print(error)
                }
            }
    }
}

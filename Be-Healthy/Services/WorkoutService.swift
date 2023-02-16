//
//  WorkoutService.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation
import Alamofire

final class WorkoutService {
    // MARK: 목표 운동 시간
    /// 목표 운동 시간 설정
    func setWorkoutGoal(hour: Int, minute: Int, completion: @escaping (APIResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-goal")!
        
        let params = [
            "hour": hour,
            "minute": minute
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    /// 목표 운동 시간 조회
    func getWorkoutGoal(completion: @escaping (WorkoutGoalResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-goal")!

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: WorkoutGoalResultData.self) { response in
                switch response.result {
                case .success:
                    guard let result = response.value else { return }
                    
                    let data = WorkoutGoalResult(
                        statusCode: response.response?.statusCode,
                        result: result)
                    
                    completion(data)
                    
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    // MARK: 운동 기록
    /// 운동 기록 추가
    func addWorkoutRecord(date: String, record: WorkoutRecordForDate, completion: @escaping (AddWorkoutRecordResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-logs")!
        
        let params = [
            "name": record.workoutName,
            "emoji": record.emoji,
            "date": date,
            "startTime": record.startTime,
            "endTime": record.endTime,
            "intensity": record.intensity,
            "comment": record.comment
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: AddWorkoutRecordResultData.self) { response in
                guard let result = response.value else { return }
                
                let data = AddWorkoutRecordResult(
                    statusCode: response.response?.statusCode,
                    result: result)
                
                completion(data)
            }
    }
    
    /// 운동 기록 수정
    func updateWorkoutRecord(date: String, record: WorkoutRecordForDate, completion: @escaping (APIResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt), let idx = record.idx else { return }
        
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-logs/\(idx)")!
        
        let params = [
            "name": record.workoutName,
            "emoji": record.emoji,
            "date": date,
            "startTime": record.startTime,
            "endTime": record.endTime,
            "intensity": record.intensity,
            "comment": record.comment
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .patch, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    /// 운동 기록 삭제
    func deleteWorkoutRecord(_ idx: Int, completion: @escaping (APIResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-logs/\(idx)")!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    /// 특정 년/월 기준 날짜별 운동 시간 조회
    func getWorkoutRecords(year: Int, month: Int, completion: @escaping (WorkoutTimesResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-logs/workout-time")!
        
        let params = [
            "year": year,
            "month": month
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .get, parameters: params, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: WorkoutTimesResultData.self) { response in
                guard let result = response.value else { return }
                
                let data = WorkoutTimesResult(
                    statusCode: response.response?.statusCode,
                    result: result)
                
                completion(data)
            }
    }
    
    /// 특정 날짜 기준 운동 기록 조회
    func getWorkoutRecords(date: String, completion: @escaping (WorkoutRecordsResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-logs")!
        
        let params = [
            "date": date,
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .get, parameters: params, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: WorkoutRecordsResultData.self) { response in
                guard let result = response.value else { return }
                
                let data = WorkoutRecordsResult(
                    statusCode: response.response?.statusCode,
                    result: result)
                
                completion(data)
            }
    }
    
    /// 특정 idx 기준 운동 기록
    func getWorkoutRecord(_ idx: Int, completion: @escaping (WorkoutRecordResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/workout-logs/\(idx)")!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
    
        AF.request(url, method: .get, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: WorkoutRecordResultData.self) { response in
                guard let result = response.value else { return }
                
                print(result)
                
                let data = WorkoutRecordResult(
                    statusCode: response.response?.statusCode,
                    result: result)
                
                print(data)
                completion(data)
            }
    }
}

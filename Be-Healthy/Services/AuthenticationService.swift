//
//  AuthenticationService.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/12.
//
// 회원 인증 관련 API 호출 처리

import Foundation
import Alamofire

class AuthenticationService {
    static let shared = AuthenticationService()
    
    /// 회원가입
    func signup(user: User, completion: @escaping (SignUpResultData) -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth/signup")!
        
        let params = [
            "email": user.email,
            "password": user.password,
            "name": user.name,
            "emailVerificationCode": user.verificationCode
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: SignUpResultData.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    
                    completion(data)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    /// 로그인
    func login(email: String, password: String, completion: @escaping (LoginResultData) -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth")!
        
        let params = [
            "email": email,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
    
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: LoginResultData.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    
                    completion(data)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    /// 인증번호 요청
    func requestVerififcationCode(email: String, purpose: String, completion: @escaping (RequestVerificationCodeResultData) -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth/email-verification/request")!
        
        let params = [
            "email": email,
            "purpose": purpose,
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: RequestVerificationCodeResultData.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    
                    completion(data)
//                    if let expireAt = data.expireAt { // 인증번호 발송 성공
//                        print("expireAt ::: \(expireAt)")
//                    } else if let _ = data.errorCode, let reason = data.reason { // 인증번호 발송 실패
//                        print(reason)
//                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    /// 인증번호 검증
    func verifyCode(email: String, purpose: String, emailVerificationCode: String, completion: @escaping (VerifyCodeResultData) -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth/email-verification/verify")!
        
        let params = [
            "email": email,
            "purpose": purpose,
            "emailVerificationCode": emailVerificationCode
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: VerifyCodeResultData.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    
                    completion(data)
//                    if let _ = data.errorCode, let reason = data.reason { // 인증번호 검증 실패
//                        print(reason)
//                    } else { // 인증번호 검증 성공
//
//                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
}

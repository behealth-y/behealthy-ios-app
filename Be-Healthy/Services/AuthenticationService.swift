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
    
    // MARK: 로그인
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
    
    // MARK: 회원가입
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
    
    /// 이메일 중복확인
    func checkEmailDuplicate(email: String, completion: @escaping (ErrorData) -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth/email-password-user/\(email)")!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
    
        AF.request(url, method: .head, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ErrorData.self) { response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    
                    print(response.response?.headers)
                    print(data)
                    
                    print(data)
                    completion(data)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    // MARK: 비밀번호 재설정
    func resetPassword(email: String, toBePassword: String, verificationCode: String, completion: @escaping (ErrorData) -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth/email-password-user/password")!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let params = [
            "email": email,
            "toBePassword": toBePassword,
            "emailVerificationCode": verificationCode
        ]
    
        AF.request(url, method: .patch, parameters: params ,encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ErrorData.self) { response in
                switch response.result {
                case .success:
                    
                    guard let data = response.value else { return }
                    
                    print(data)
                    completion(data)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    // MARK: 인증번호
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
                case let .failure(error):
                    print(error)
                }
            }
    }
}

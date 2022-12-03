//
//  AuthenticationService.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/12.
//

import Foundation
import Alamofire

class AuthenticationService {
    static let shared = AuthenticationService()
    
    /// 회원가입
    func signup(user: User) {
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
    
        print("\(#function) url : \(url), params: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    print(data)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    /// 로그인
    func login(email: String, password: String) {
        let url = URL(string: "\(Config().apiUrl)/api/auth")!
        
        let params = [
            "email": email,
            "password": password
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
    
        print("\(#function) url : \(url), params: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    print(data)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    // 인증번호 요청
    func requestCertNumber(email: String, completion: @escaping () -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth/email-verification")!
        
        let params = [
            "email": email,
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
    
        print("\(#function) url : \(url), params: \(params)")
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseString { response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    print(data)
                    completion()
                case let .failure(error):
                    print(error)
                }
            }
    }
}

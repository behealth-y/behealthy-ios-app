//
//  AuthenticationService.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/12.
//
// 회원 인증 관련 API 호출 처리

import Foundation
import Alamofire

final class AuthenticationService {    
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
    func signUp(user: User, completion: @escaping (APIResult) -> Void) {
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
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    /// 이메일 중복확인
    func checkEmailDuplicate(email: String, completion: @escaping (APIResult) -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth/email-password-user/\(email)")!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
    
        AF.request(url, method: .head, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    // MARK: 비밀번호 재설정
    func resetPassword(email: String, toBePassword: String, verificationCode: String, completion: @escaping (APIResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
        
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let url = URL(string: "\(Config().apiUrl)/api/auth/email-password-user/password")!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
        
        let params = [
            "email": email,
            "toBePassword": toBePassword,
            "emailVerificationCode": verificationCode
        ]
    
        AF.request(url, method: .patch, parameters: params ,encoding: JSONEncoding.default, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    // MARK: 닉네임 변경
    func changeNickname(_ name: String, completion: @escaping (APIResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"), let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
        
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let userId = jwtDecode.payload.userId
        
        let url = URL(string: "\(Config().apiUrl)/api/users/\(userId)/name")!
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
        
        let params = [
            "name": name
        ]
    
        print("ASDASFASDFASDF ::: \(url)")
        print("ASDASFASDFASDF ::: \(headers)")
        print("ASDASFASDFASDF ::: \(params)")
        
        AF.request(url, method: .patch, parameters: params ,encoding: JSONEncoding.default, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    // MARK: 인증번호
    /// 인증번호 요청
    func requestVerififcationCode(email: String, purpose: String, completion: @escaping (RequestVerificationCodeResult) -> Void) {
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
                    guard let result = response.value else { return }
                    
                    let data = RequestVerificationCodeResult(
                        statusCode: response.response?.statusCode,
                        result: result)
                    
                    completion(data)
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    /// 인증번호 검증
    func verifyCode(email: String, purpose: String, emailVerificationCode: String, completion: @escaping (APIResult) -> Void) {
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
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
    
    // MARK: 회원 탈퇴
    func delete(completion: @escaping (APIResult) -> Void) {
        guard let jwt = UserDefaults.standard.string(forKey: "jwt"), let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"),  let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                
        let authenticator = MyAuthenticator()
        let expireAt = Double(jwtDecode.payload.exp)
        let credential = MyAuthenticationCredential(accessToken: jwt,
                                                    refreshToken: refreshToken,
                                                    expiredAt: Date(timeIntervalSince1970: expireAt))
        
        let myAuthencitationInterceptor = AuthenticationInterceptor(authenticator: authenticator, credential: credential)
        
        let userId = jwtDecode.payload.userId

        let url = URL(string: "\(Config().apiUrl)/api/users/\(userId)")!
        
        let params = [
            "userId": userId,
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
        
        AF.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: myAuthencitationInterceptor)
            .responseDecodable(of: APIResultData.self) { response in
                if let data = response.value {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: data))
                } else {
                    completion(APIResult(statusCode: response.response?.statusCode, errorData: nil))
                }
            }
    }
}

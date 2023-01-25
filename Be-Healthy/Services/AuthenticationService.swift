//
//  AuthenticationService.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/12.
//

import Foundation
import Alamofire
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

protocol AuthenticationServiceDelegate: NSObject {
    func emailLoginSuccess()
    func emailLoginFail(reason: String)
}

class AuthenticationService {
    weak var delegate: AuthenticationServiceDelegate?
    
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
    
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: LoginResultData.self) { [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.value else { return }
                    
                    if let token = data.token { // 로그인 성공
                        UserDefaults.standard.set(token, forKey: "jwt")
                        self?.delegate?.emailLoginSuccess()
                    } else if let _ = data.errorCode, let reason = data.reason { // 로그인 실패
                        self?.delegate?.emailLoginFail(reason: reason)
                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    /// 카카오 로그인
    func kakaoLogin(completion: @escaping () -> Void) {
        // 카카오톡이 설치되어 있는 경우
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오 로그인
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    completion()
                }
            }
        } else {
            // 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                if let error = error {
                    print(error)
                } else {
                    completion()
                }
            }
        }
    }
    
    /// 카카오 로그아웃
    func kakaoLogout(completion: @escaping () -> Void) {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
            }
        }
    }
    
    /// 인증번호 요청
    func requestVerififcationCode(email: String, purpose: String) {
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
                    
                    if let expireAt = data.expireAt { // 인증번호 발송 성공
                        print("expireAt ::: \(expireAt)")
                    } else if let _ = data.errorCode, let reason = data.reason { // 인증번호 발송 실패
                        print(reason)
                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
    
    /// 인증번호 검증
    func verifyCode(email: String, purpose: String, emailVerificationCode: String) {
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
                    
                    if let _ = data.errorCode, let reason = data.reason { // 인증번호 검증 실패
                        print(reason)
                    } else { // 인증번호 검증 성공
                        
                    }
                case let .failure(error):
                    print(error)
                }
            }
    }
}

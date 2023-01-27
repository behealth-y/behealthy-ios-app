//
//  KakaoLoginManager.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

protocol KakaoLoginManagerDelegate: NSObject {
    func kakaoLoginSuccess()
    func kakaoLoginFail()
    func kakaoLogoutSuccess()
    func kakaoLogoutFail()
}

final class KakaoLoginManager {
    weak var delegate: KakaoLoginManagerDelegate?
    
    /// 카카오 로그인
    func kakaoLogin() {
        // 카카오톡이 설치되어 있는 경우
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카카오 로그인
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error)
                    self?.delegate?.kakaoLoginFail()
                } else {
                    self?.delegate?.kakaoLoginSuccess()
                }
            }
        } else {
            // 카카오 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error {
                    print(error)
                    self?.delegate?.kakaoLoginFail()
                } else {
                    self?.delegate?.kakaoLoginSuccess()
                }
            }
        }
    }
    
    /// 카카오 로그아웃
    func kakaoLogout() {
        UserApi.shared.logout { [weak self] (error) in
            if let error = error {
                print(error)
                self?.delegate?.kakaoLogoutFail()
            }
            else {
                self?.delegate?.kakaoLoginSuccess()
            }
        }
    }
}

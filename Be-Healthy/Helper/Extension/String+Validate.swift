//
//  String+Validate.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/12/29.
//

import Foundation

import Foundation

extension String {
    /// 이메일 형식
    func emailValidate() -> Bool {
        let regex = "[a-zA-Z0-9+-\\_.]+@[0-9a-zA-Z.-]+\\.[a-zA-Z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    /// 비밀번호 형식 (영문, 숫자, 특수문자 조합 최소 8자)
    func passwordValidate() -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,50}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }
    
    /// 비밀번호 입력 시 영문, 숫자, 특수문자만 입력 가능 되도록 함
    func passwordInputValidate() -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[{]}\\|;:'\",<.>/?")
        let inputCharacterSet = CharacterSet(charactersIn: self)
        return allowedCharacterSet.isSuperset(of: inputCharacterSet)
    }
    
    /// 닉네임 (2 ~ 8자리)
    func nicknameValiate() -> Bool {
        return self.count >= 2 && self.count <= 8
    }
    
    /// 인증번호 (6자리인지)
    func verificationCodeValidate() -> Bool {
        return self.count == 6
    }
}

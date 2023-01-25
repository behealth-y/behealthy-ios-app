//
//  AppleLoginManager.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/26.
//

import Foundation
import AuthenticationServices

protocol AppleLoginManagerDelegate: NSObject {
    func appleLoginSuccess()
    func appleLoginFail()
}

final class AppleLoginManager: NSObject {
    weak var viewController: UIViewController?
    weak var delegate: AppleLoginManagerDelegate?
    
    func setAppleLoginPresentationAnchorView(_ view: UIViewController) {
        self.viewController = view
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate {
    /// 사용자 인증 후 처리
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let userName = appleIDCredential.fullName
            let userEmail = appleIDCredential.email
            
            print("apple Login Info ::: (name: \(userName!), email, \(userEmail!))")
            delegate?.appleLoginSuccess()
        }
    }
    
    /// 사용자 인증 실패
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        delegate?.appleLoginFail()
    }
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
}

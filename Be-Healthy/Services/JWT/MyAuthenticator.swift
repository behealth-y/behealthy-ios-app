//
//  MyAuthenticator.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/16.
//

import Foundation
import Alamofire
import UIKit

class MyAuthenticator: Authenticator {
    typealias Credential = MyAuthenticationCredential

    func apply(_ credential: Credential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
        urlRequest.addValue(credential.refreshToken, forHTTPHeaderField: "refresh-token")
    }

    func didRequest(_ urlRequest: URLRequest, with response: HTTPURLResponse, failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: Credential) -> Bool {
        // bearerToken의 urlRequest 대해서만 refresh를 시도 (true)
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }

    func refresh(_ credential: Credential, for session: Session, completion: @escaping (Result<Credential, Error>) -> Void) {
        guard let refreshToken = UserDefaults.standard.string(forKey: "refreshToken") else { return }
        
        // MARK: refreshToken 만료 시 로그아웃 처리
        if let refreshTokenDecode = RefreshToken(jsonWebToken: refreshToken) {
            let expireAt = Double(refreshTokenDecode.payload.exp)

            if Date() >= Date(timeIntervalSince1970: expireAt) {
                AuthenticationService().logout()
                
                DispatchQueue.main.async {
                    let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as! SceneDelegate
                    let nav = UINavigationController(rootViewController: FirstViewController())
                    
                    sceneDelegate.window?.rootViewController = nav
                }
                return
            }
        }
        
        let url = URL(string: "\(Config().apiUrl)/api/auth/refresh")!
        
        let params = [
            "refreshToken": refreshToken
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
    
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: LoginResultData.self) { response in
                switch response.result {
                case .success:
                    print(#function)
                    guard let data = response.value, let jwt = data.accessToken, let refreshToken = UserDefaults.standard.string(forKey: "refreshToken"), let jwtDecode = JSONWebToken(jsonWebToken: jwt) else { return }
                    
                    UserDefaults.standard.set(jwt, forKey: "jwt")

                    let expireAt = Double(jwtDecode.payload.exp)
                    let credential = MyAuthenticationCredential(accessToken: jwt,
                                                                refreshToken: refreshToken,
                                                                expiredAt: Date(timeIntervalSince1970: expireAt))
                    completion(.success(credential))
                case let .failure(error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
}

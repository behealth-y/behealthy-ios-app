//
//  MyAuthenticator.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/16.
//

import Foundation
import Alamofire

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
                    guard let data = response.value, let jwt = data.accessToken else { return }
                    
                    UserDefaults.standard.set(jwt, forKey: "jwt")
                    completion(.success(credential))
                case let .failure(error):
                    print(error)
                    completion(.failure(error))
                }
            }
    }
}

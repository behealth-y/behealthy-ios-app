//
//  WorkOutService.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation
import Alamofire

final class WorkOutService {
    // MARK: 목표 운동시간 설정
    func setWorkOutGoal(hour: Int, minute: Int, completion: @escaping (ErrorData) -> Void) {
        let url = URL(string: "\(Config().apiUrl)/api/auth")!
        
        let params = [
            "hour": hour,
            "minute": minute
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
    
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: ErrorData.self) { response in
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

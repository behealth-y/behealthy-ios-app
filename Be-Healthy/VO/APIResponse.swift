//
//  APIResponse.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/29.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    var statusCode: Int?
    let data: T?
    
    enum CodingKeys: CodingKey {
        case statusCode, data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = (try? values.decode(Int.self, forKey: .statusCode)) ?? nil
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}

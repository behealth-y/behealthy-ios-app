//
//  ResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/27.
//

import Foundation

struct APIResult {
    let statusCode: Int?
    let errorData: APIResultData?
}


struct APIResultData: Codable {
    let errorCode, reason: String?
}

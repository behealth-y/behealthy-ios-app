//
//  LoginResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/12.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginResultData = try? newJSONDecoder().decode(LoginResultData.self, from: jsonData)

import Foundation

// MARK: - LoginResultData
struct LoginResultData: Codable {
    let token: String?
    let errorCode, reason: String?
}

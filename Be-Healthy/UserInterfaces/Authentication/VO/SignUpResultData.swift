//
//  SignUpResultData.swift
//  Be-Healthy
//
//  Created by 박현우 on 2022/10/12.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let signUpResultData = try? newJSONDecoder().decode(SignUpResultData.self, from: jsonData)

import Foundation

// MARK: - SignUpResultData
struct SignUpResultData: Codable {
    let timestamp, error, path: String?
    let status: Int?
}

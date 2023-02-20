//
//  RefreshToken.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/20.
//

import Foundation

struct RefreshToken {
    let header: RefreshTokenHeader
    let payload: RefreshTokenPayload
    let signature: String
}

extension RefreshToken {

    init?(jsonWebToken: String) {
        let encodedData = { (string: String) -> Data? in
            var encodedString = string.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
        
            switch (encodedString.utf16.count % 4) {
            case 2:     encodedString = "\(encodedString)=="
            case 3:     encodedString = "\(encodedString)="
            default:    break
            }
        
            return Data(base64Encoded: encodedString)
        }

        let components = jsonWebToken.components(separatedBy: ".")
    
        guard components.count == 3,
            let headerData = encodedData(components[0] as String),
            let payloadData = encodedData(components[1] as String) else { return nil }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            header    = try decoder.decode(RefreshTokenHeader.self, from: headerData)
            payload   = try decoder.decode(RefreshTokenPayload.self, from: payloadData)
            signature = components[2] as String
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

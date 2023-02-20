//
//  RefreshTokenHeader.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/02/20.
//

import Foundation

struct RefreshTokenHeader {
    let algorithm: String
}

extension RefreshTokenHeader: Codable {

    private enum Key: String, CodingKey {
        case algorithm = "alg"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
    
        do { try container.encode(algorithm, forKey: .algorithm) } catch { throw error }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        do { algorithm = try container.decode(String.self, forKey: .algorithm) } catch { throw error }
    }
}

//
//  JSONWebTokenPayload.swift
//  Be-Healthy
//
//  Created by 박현우 on 2023/01/30.
//

import Foundation

/*
   "userId": 9,
   "name": "Harry",
   "sub": "9",
   "iat": 1675055643,
   "exp": 1675059243
 */
struct JSONWebTokenPayload {
    let userId: Int
    let name: String?
    let sub: String
    let iat: Int
    let exp: Int
}

extension JSONWebTokenPayload: Codable {

    enum CodingKeys: CodingKey {
        case userId, name, sub, iat, exp
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
    
        do { try container.encode(userId, forKey: .userId) } catch { throw error }
        do { try container.encode(name, forKey: .name) } catch { throw error }
        do { try container.encode(sub, forKey: .sub) } catch { throw error }
        do { try container.encode(iat, forKey: .iat) } catch { throw error }
        do { try container.encode(exp, forKey: .exp) } catch { throw error }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        do { userId = try container.decode(Int.self, forKey: .userId) } catch { throw error }
        do { name = try container.decode(String.self, forKey: .name) } catch { throw error }
        do { sub = try container.decode(String.self, forKey: .sub) } catch { throw error }
        do { iat = try container.decode(Int.self, forKey: .iat) } catch { throw error }
        do { exp = try container.decode(Int.self, forKey: .exp) } catch { throw error }
    }
}

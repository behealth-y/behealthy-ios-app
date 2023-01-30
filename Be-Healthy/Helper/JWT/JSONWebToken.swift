import Foundation

struct JSONWebToken {
    let header: JSONWebTokenHeader
    let payload: JSONWebTokenPayload
    let signature: String
}

extension JSONWebToken {

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
            header    = try decoder.decode(JSONWebTokenHeader.self, from: headerData)
            payload   = try decoder.decode(JSONWebTokenPayload.self, from: payloadData)
            signature = components[2] as String
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

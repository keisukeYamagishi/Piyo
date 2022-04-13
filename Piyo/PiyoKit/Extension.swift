//
//  Extension.swift
//  Piyo
//
//  Created by Shichimitoucarashi on 2020/05/30.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import Foundation

public extension String {
    /*
     * Dictionary Converts a value to a string.
     * key=value&key=value
     * {
     *   key : value,
     *   key : value
     * }
     *
     */
    var toDictonary: [String: String] {
        var parameters: [String: String] = [:]
        _ = components(separatedBy: "&").compactMap {
            let value = $0.components(separatedBy: "=")
            parameters[value[0]] = value[1]
        }
        return parameters
    }

    func toURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw NSError(domain: "Invalid url", code: 10001)
        }
        return url
    }
}

public extension Data {
    var rawBytes: [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length: count * MemoryLayout<UInt8>.size)
        return bytesArray
    }

    init(bytes: [UInt8]) {
        self.init(bytes: bytes, count: bytes.count)
    }

    mutating func append(_ bytes: [UInt8]) {
        append(bytes, count: bytes.count)
    }
}

public extension Int {
    func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }
}

public func arrayOfBytes<T>(_ value: T, length: Int? = nil) -> [UInt8] {
    let totalBytes = length ?? (MemoryLayout<T>.size * 8)
    let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
    valuePointer.pointee = value

    let bytesPointer = valuePointer.withMemoryRebound(to: UInt8.self, capacity: 1) { $0 }
    var bytes = [UInt8](repeating: 0, count: totalBytes)
    for byte in 0 ..< min(MemoryLayout<T>.size, totalBytes) {
        bytes[totalBytes - 1 - byte] = (bytesPointer + byte).pointee
    }

    valuePointer.deinitialize(count: 1)
    valuePointer.deallocate()

    return bytes
}

public extension Dictionary {
    /*
     * encoded Dictionary's value
     *
     */
    func encodedQuery(using _: String.Encoding) -> String {
        var parts = [String]()

        for (key, value) in self {
            let keyString = "\(key)".percentEncode()
            let valueString = "\(value)".percentEncode(keyString == "status")
            let query: String = "\(keyString)=\(valueString)"
            parts.append(query)
        }
        return parts.joined(separator: "&")
    }
}

public class URI {
    public static func encode(param: [String: String]) -> String {
        return URI().encode(param: param)
    }

    public func encode(param: [String: String]) -> String {
        return param.map { "\($0)=\($1.percentEncode())" }.joined(separator: "&")
    }

    /*
     * Base64 encode with comsumer key and comsmer secret
     * Twitter Beare token
     */
    public static var credentials: String {
        let encodedKey = TwitterKey.shared.api.key.percentEncode() // comsumerKey.UrlEncode()
        let encodedSecret = TwitterKey.shared.api.secret.percentEncode() // comsumerSecret.UrlEncode()
        let bearerTokenCredentials = "\(encodedKey):\(encodedSecret)"
        guard let data = bearerTokenCredentials.data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString(options: [])
    }

    public static func twitterEncode(param: [String: String]) -> String {
        return URI().twitterEncode(param: param)
    }

    /*
     * It converts the value of Dictionary type
     * URL encoded into a character string and returns it.
     */
    public func twitterEncode(param: [String: String]) -> String {
        var parameter = String()

        var keys = Array(param.keys)

        keys.sort { $0 < $1 }

        for index in 0 ..< keys.count {
            let val: String
            if keys[index] == "oauth_callback"
                || keys[index] == "oauth_signature"
            {
                val = param[keys[index]]!
            } else {
                val = (param[keys[index]]?.percentEncode())!
            }
            if index == (keys.count - 1) {
                parameter += keys[index] + "=" + val
            } else {
                parameter += keys[index] + "=" + val + "&"
            }
        }
        return parameter
    }
}

public extension String {
    /*
     * PersentEncode
     */
    func percentEncode(_ encodeAll: Bool = false) -> String {
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        if !encodeAll {
            allowedCharacterSet.insert(charactersIn: "[]")
        }
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}

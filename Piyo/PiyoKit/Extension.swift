//
//  Extension.swift
//  Piyo
//
//  Created by Shichimitoucarashi on 2020/05/30.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import Foundation

extension String {
    /*
     * Dictionary Converts a value to a string.
     * key=value&key=value
     * {
     *   key : value,
     *   key : value
     * }
     *
     */
    var toDictionary: [String: String] {
        var parameters: [String: String] = [:]
        _ = components(separatedBy: "&").compactMap {
            let value = $0.components(separatedBy: "=")
            parameters[value[0]] = value[1]
        }
        return parameters
    }

    func toUrl() throws -> URL {
        guard let url = URL(string: self) else {
            throw NSError(domain: "Invalid URL",
                          code: -10001,
                          userInfo: ["LocalizedSuggestion": "Incorrect URL, Review the URL"])
        }
        return url
    }
}

extension Data {
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

extension Int {
    func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        arrayOfBytes(self, length: totalBytes)
    }
}

func arrayOfBytes<T>(_ value: T, length: Int? = nil) -> [UInt8] {
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

extension Dictionary {
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

extension String {
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

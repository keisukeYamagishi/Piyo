//
//  Extention.swift
//  HttpSession
//
//  Created by Shichimitoucarashi on 12/1/18.
//  Copyright © 2018 keisuke yamagishi. All rights reserved.
//

import UIKit

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
    public var queryStringParameters: [String: String] {

        var parameters: [String: String] = [:]

        let scanner = Scanner(string: self)

        var key: NSString?
        var value: NSString?

        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo("=", into: &key)
            scanner.scanString("=", into: nil)

            value = nil
            scanner.scanUpTo("&", into: &value)
            scanner.scanString("&", into: nil)

            if let key = key as String?, let value = value as String? {
                parameters.updateValue(value, forKey: key)
            }
        }
        return parameters
    }
}

extension Data {

    public var rawBytes: [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length: count * MemoryLayout<UInt8>.size)
        return bytesArray
    }

    public init(bytes: [UInt8]) {
        self.init(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    }

    public mutating func append(_ bytes: [UInt8]) {
        self.append(UnsafePointer<UInt8>(bytes), count: bytes.count)
    }
}

extension Int {

    public func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }
}

public func arrayOfBytes<T>(_ value: T, length: Int? = nil) -> [UInt8] {
    let totalBytes = length ?? (MemoryLayout<T>.size * 8)
    let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
    valuePointer.pointee = value

    let bytesPointer = valuePointer.withMemoryRebound(to: UInt8.self, capacity: 1) { $0 }
    var bytes = [UInt8](repeating: 0, count: totalBytes)
    for j in 0..<min(MemoryLayout<T>.size, totalBytes) {
        bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
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
    public func encodedQuery(using encoding: String.Encoding) -> String {
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

class URI {

    /*
     * Base64 encode with comsumer key and comsmer secret
     * Twitter Beare token
     */
    public static var credentials: String {
        let encodedKey = TwitterKey.shared.api.key.percentEncode() //comsumerKey.UrlEncode()
        let encodedSecret = TwitterKey.shared.api.secret.percentEncode() //comsumerSecret.UrlEncode()
        let bearerTokenCredentials = "\(encodedKey):\(encodedSecret)"
        guard let data = bearerTokenCredentials.data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString(options: [])
    }

    public static func twitterEncode (param: [String: String]) -> String {
        return URI().twitterEncode(param: param)
    }

    /*
     * It converts the value of Dictionary type
     * URL encoded into a character string and returns it.
     */
    public func twitterEncode(param: [String: String]) -> String {

        var parameter: String = String()

        var keys: Array = Array(param.keys)

        keys.sort {$0 < $1}

        for index in 0..<keys.count {
            let val: String
            if "oauth_callback" == keys[index]
                || "oauth_signature" == keys[index] {
                val = param[keys[index]]!
            } else {
                val = (param[keys[index]]?.percentEncode())!
            }
            if index == (keys.count - 1) {
                parameter += keys[index] + "=" +  val
            } else {
                parameter += keys[index] + "=" +  val + "&"
            }
        }
        return parameter
    }
}

extension String {

    /*
     * PersentEncode
     */
    public func percentEncode(_ encodeAll: Bool = false) -> String {
        var allowedCharacterSet: CharacterSet = .urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        if !encodeAll {
            allowedCharacterSet.insert(charactersIn: "[]")
        }
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)!
    }
}
//
//public extension Request {
//
//    func postTweet(url: String, tweet: String, img: UIImage) -> URLRequest {
//
//        var parameters: [String: String] = [:]
//        parameters["status"] = tweet
//
//        let tweetMultipart = Multipart()
//
//        let body = tweetMultipart.tweetMultipart(param: parameters, img: img)
//
//        let header: [String: String] = ["Content-Type": "multipart/form-data; boundary=\(tweetMultipart.bundary)",
//            "Authorization": Twitter().signature(url: url, method: .post, param: parameters, isUpload: true),
//            "Content-Length": body.count.description]
//
//        self.headers(header: header)

//        self.urlReq!.httpBody = body
//
//        return self.urlReq
//    }
//
//}

extension Multipart {
    func tweetMultipart (param: [String: String], img: UIImage) -> Data {

        var body: Data = Data()

        let multipartData = Multipart.mulipartContent(with: self.bundary, data: img.pngData()!, fileName: "media.jpg", parameterName: "media[]", mimeType: "application/octet-stream")
        body.append(multipartData)

        for (key, value): (String, String) in param {
            body.append("\r\n--\(self.bundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)".data(using: .utf8)!)
        }

        body.append("\r\n--\(self.bundary)--\r\n".data(using: .utf8)!)
        return body
    }
}

open class Multipart {

    public struct data {
        public var fileName: String!
        public var mimeType: String!
        public var data: Data!
        public init() {
            self.fileName = ""
            self.mimeType = ""
            self.data = Data()
        }
    }

    public var bundary: String
    public var uuid: String

    public init() {
        self.uuid = UUID().uuidString
        self.bundary = String(format: "----\(self.uuid)")
    }

    public func multiparts(params: [String: Multipart.data]) -> Data {

        var post: Data = Data()

        for(key, value) in params {
            let dto: Multipart.data = value
            post.append(multipart(key: key, fileName: dto.fileName as String, mineType: dto.mimeType, data: dto.data))
        }
        return post
    }

    public func multipart(key: String, fileName: String, mineType: String, data: Data) -> Data {

        var body = Data()
        let CRLF = "\r\n"
        body.append(("--\(self.bundary)" + CRLF).data(using: .utf8)!)
        body.append(("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\"" + CRLF).data(using: .utf8)!)
        body.append(("Content-Type: \(mineType)" + CRLF + CRLF).data(using: .utf8)!)
        body.append(data)
        body.append(CRLF.data(using: .utf8)!)
        body.append(("--\(self.bundary)--" + CRLF).data(using: .utf8)!)

        return body
    }

    public static func mulipartContent(with boundary: String,
                                       data: Data,
                                       fileName: String?,
                                       parameterName: String,
                                       mimeType mimeTypeOrNil: String?) -> Data {
        let mimeType = mimeTypeOrNil ?? "application/octet-stream"
        let fileNameContentDisposition = fileName != nil ? "filename=\"\(fileName!)\"" : ""
        let contentDisposition = "Content-Disposition: form-data; name=\"\(parameterName)\"; \(fileNameContentDisposition)\r\n"

        var tempData = Data()
        tempData.append("--\(boundary)\r\n".data(using: .utf8)!)
        tempData.append(contentDisposition.data(using: .utf8)!)
        tempData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        tempData.append(data)
        return tempData
    }
}


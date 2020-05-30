//
//  Extention.swift
//  HttpSession
//
//  Created by Shichimitoucarashi on 12/1/18.
//  Copyright © 2018 keisuke yamagishi. All rights reserved.
//

import UIKit
import Piyo

open class Request {

    public static func create(url: String, method: String, header: [String:String]) -> URLRequest? {
        do {
            var request = try URLRequest(url: url.toURL())
            request.httpMethod = method
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
            return request
        }catch{
            print("Error: \(error)")
        }
        return nil
    }
    
    public static func tweet(url: String, tweet: String, img: UIImage = UIImage()) -> URLRequest? {

        do {
            var request = try URLRequest(url: url.toURL())
            
            var parameters: [String: String] = [:]
            parameters["status"] = tweet

            let tweetMultipart = Multipart()

            let body = tweetMultipart.tweetMultipart(param: parameters, img: img)

            guard let signature = Piyo.signature(url: url, method: .post, param: parameters, upload: true) else {
                return nil
            }
            let header: [String: String] = ["Content-Type": "multipart/form-data; boundary=\(tweetMultipart.bundary)",
                "Authorization": signature,
                //OAuthKit.authorizationHeader(for: try url.toURL(), method: "POST", param: parameters, isMediaUpload: true),
                "Content-Length": body.count.description]

            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }

            request.httpBody = body
            request.httpMethod = "POST"
            return request
        }catch{
            print (error)
        }
        return nil
    }
}

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


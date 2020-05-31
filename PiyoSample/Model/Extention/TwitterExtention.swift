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

    public static func create(url: String,
                              method: String,
                              header: [String: String]) -> URLRequest? {
        do {
            var request = try URLRequest(url: url.toURL())
            request.httpMethod = method
            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
            return request
        } catch {
            print("Error: \(error)")
        }
        return nil
    }

    public static func tweetWithMedia(url: String, tweet: String, img: UIImage = UIImage()) -> URLRequest? {

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
                "Content-Length": body.count.description]

            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }

            request.httpBody = body
            request.httpMethod = "POST"
            return request
        } catch {
            print(error)
        }
        return nil
    }

    public static func tweet(url: String, tweet: String) -> URLRequest? {
        do {
            var request = try URLRequest(url: url.toURL())
            let parameters: [String: String] = ["status": tweet]
            let value: String = URI.twitterEncode(param: parameters)
            let body: Data = value.data(using: .utf8)! as Data
            guard let signature = Piyo.signature(url: url,
                                                 method: .post,
                                                 param: parameters) else {
                return nil
            }

            let header: [String: String] = ["Authorization": signature,
                                            "Content-Length": body.count.description]

            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }

            request.httpBody = body
            request.httpMethod = "POST"
            return request
        } catch {
            print(error)
        }
        return nil
    }
}

extension Multipart {
    func tweetMultipart (param: [String: String], img: UIImage) -> Data {

        var body: Data = Data()
        let multipartData = Multipart.mulipartContent(with: self.bundary,
                                                      data: img.pngData()!,
                                                      fileName: "media.jpg",
                                                      parameter: "media[]",
                                                      mimeType: "application/octet-stream")
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

    public var bundary: String
    public var uuid: String

    public init() {
        self.uuid = UUID().uuidString
        self.bundary = String(format: "----\(self.uuid)")
    }

    public static func mulipartContent(with boundary: String,
                                       data: Data,
                                       fileName: String?,
                                       parameter: String,
                                       mimeType mimeTypeOrNil: String?) -> Data {
        let mimeType = mimeTypeOrNil ?? "application/octet-stream"
        let FCD = fileName != nil ? "filename=\"\(fileName!)\"" : ""
        let contentDisposition = "Content-Disposition: form-data; name=\"\(parameter)\"; \(FCD)\r\n"

        var tempData = Data()
        tempData.append("--\(boundary)\r\n".data(using: .utf8)!)
        tempData.append(contentDisposition.data(using: .utf8)!)
        tempData.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        tempData.append(data)
        return tempData
    }
}

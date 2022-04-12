//
//  Request.swift
//  Piyo
//
//  Created by keisuke yamagishi on 2022/04/12.
//  Copyright © 2022 Shichimitoucarashi. All rights reserved.
//

import Foundation

class Request {
    public static func create(url: String,
                              header: [String: String],
                              parameter: [String: String]? = nil) -> URLRequest?
    {
        do {
            var request = try URLRequest(url: url.toURL())
            request.httpMethod = "POST"

            if let para = parameter {
                let value: String = URI.encode(param: para)
                guard let data = value.data(using: .utf8) as Data? else { return nil }

                let header: [String: String] = ["Content-Type": "application/x-www-form-urlencoded",
                                                "Accept": "application/x-www-form-urlencoded",
                                                "Content-Length": data.count.description]

                header.forEach {
                    request.setValue($0.value, forHTTPHeaderField: $0.key)
                }
                request.httpBody = data
            }

            for (key, value) in header {
                request.setValue(value, forHTTPHeaderField: key)
            }
            return request
        } catch {
            print(error)
        }
        return nil
    }
}

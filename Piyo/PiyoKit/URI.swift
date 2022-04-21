//
//  URI.swift
//  Piyo
//
//  Created by keisuke yamagishi on 2022/04/19.
//  Copyright © 2022 Shichimitoucarashi. All rights reserved.
//

import Foundation

public class URI {
    public init() {}

    @inlinable
    public static func encode(param: [String: String]) -> String {
        URI().encode(param: param)
    }

    @inlinable
    public func encode(param: [String: String]) -> String {
        param.map { "\($0)=\($1.percentEncode())" }.joined(separator: "&")
    }

    /*
     * Base64 encode with comsumer key and comsmer secret
     * Twitter Beare token
     */
    @inlinable
    public static var credentials: String {
        let encodedKey = TwitterKey.shared.api.key.percentEncode() // comsumerKey.UrlEncode()
        let encodedSecret = TwitterKey.shared.api.secret.percentEncode() // comsumerSecret.UrlEncode()
        let bearerTokenCredentials = "\(encodedKey):\(encodedSecret)"
        guard let data = bearerTokenCredentials.data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString(options: [])
    }

    @inlinable
    public static func twitterEncode(param: [String: String]) -> String {
        URI().twitterEncode(param: param)
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

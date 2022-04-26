//
//  Encode.swift
//  Piyo
//
//  Created by keisuke yamagishi on 2022/04/21.
//  Copyright © 2022 Shichimitoucarashi. All rights reserved.
//

import Foundation

class Encode {
    static func encode(_ parameter: [String: String]) -> String {
        Encode().encode(parameter)
    }

    func encode(_ parameter: [String: String]) -> String {
        parameter.map { "\($0)=\($1.percentEncode())" }.joined(separator: "&")
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

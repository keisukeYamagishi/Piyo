//
//  URI.swift
//  Piyo
//
//  Created by keisuke yamagishi on 2022/04/19.
//  Copyright © 2022 Shichimitoucarashi. All rights reserved.
//

import Foundation

final class URI {
    let url: String
    let parameter: [String: String]
    let encode: Encode

    init(_ url: String,
         _ parameter: [String: String])
    {
        self.url = url
        self.parameter = parameter
        encode = Encode()
    }

    static func build(url: String,
                      parameter: [String: String]) -> String
    {
        URI(url, parameter).build()
    }

    private func encodeParameter() -> String {
        let encode = Encode()
        return encode.encode(parameter)
    }

    private func build() -> String {
        url + "?" + encodeParameter()
    }
}

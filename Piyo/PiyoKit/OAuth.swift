//
//  OAuth.swift
//  Piyo
//
//  Created by keisuke yamagishi on 2022/04/13.
//  Copyright © 2022 Shichimitoucarashi. All rights reserved.
//

import Foundation

public struct OAuth {
    public var token: String = ""
    public var secret: String = ""
    public init() {
        token = ""
        secret = ""
    }

    public init(token: String, secret: String) {
        self.token = token
        self.secret = secret
    }
}

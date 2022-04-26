//
//  Credential.swift
//  Piyo
//
//  Created by keisuke yamagishi on 2022/04/21.
//  Copyright © 2022 Shichimitoucarashi. All rights reserved.
//

import Foundation

class BearerToken {
    /*
     * Base64 encode with consumer key and consumer secret
     * Twitter Beare token
     */
    @inlinable
    static var credentials: String {
        let encodedKey = TwitterKey.shared.api.key.percentEncode()
        let encodedSecret = TwitterKey.shared.api.secret.percentEncode()
        let bearerTokenCredentials = "\(encodedKey):\(encodedSecret)"
        guard let data = bearerTokenCredentials.data(using: .utf8) else {
            return ""
        }
        return data.base64EncodedString(options: [])
    }
}

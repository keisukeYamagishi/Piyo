//
//  HMAC.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 1/28/15.
//  Copyright (c) 2015 Dongri Jin. All rights reserved.
//  https://github.com/mattdonnelly/Swifter/blob/master/Sources/HMAC.swift

import Foundation

enum HMAC {
    @inlinable
    static func sha1(key: Data, message: Data) -> Data? {
        var key = key.rawBytes
        let message = message.rawBytes

        // key
        if key.count > 64 {
            key = SHA1(message: Data(bytes: key)).calculate().rawBytes
        }

        if key.count < 64 {
            key += [UInt8](repeating: 0, count: 64 - key.count)
        }

        var opad = [UInt8](repeating: 0x5C, count: 64)
        for idx in key.indices { // enumerated() {
            opad[idx] = key[idx] ^ opad[idx]
        }
        var ipad = [UInt8](repeating: 0x36, count: 64)
        for idx in key.indices {
            ipad[idx] = key[idx] ^ ipad[idx]
        }

        let ipadAndMessageHash = SHA1(message: Data(bytes: ipad + message)).calculate().rawBytes
        let finalHash = SHA1(message: Data(bytes: opad + ipadAndMessageHash)).calculate().rawBytes
        let mac = finalHash

        return Data(bytes: mac, count: mac.count)
    }
}

//
//  SHA1.swift
//  OAuthSwift
//
//  Created by Dongri Jin on 1/28/15.
//  Copyright (c) 2015 Dongri Jin. All rights reserved.
//  https://github.com/mattdonnelly/Swifter/blob/master/Sources/SHA1.swift

import Foundation

// swiftlint:disable all
struct SHA1 {
    var message: Data

    /** Common part for hash calculation. Prepare header data. */
    @inlinable
    func prepare(_ len: Int = 64) -> Data {
        var tmpMessage: Data = message

        // Step 1. Append Padding Bits
        tmpMessage.append([0x80]) // append one bit (Byte with one bit) to message

        // append "0" bit until message length in bits ≡ 448 (mod 512)
        while tmpMessage.count % len != (len - 8) {
            tmpMessage.append([0x00])
        }

        return tmpMessage
    }

    @inlinable
    func calculate() -> Data {
        // var tmpMessage = self.prepare()
        let length = 64
        let hash: [UInt32] = [0x6745_2301, 0xEFCD_AB89, 0x98BA_DCFE, 0x1032_5476, 0xC3D2_E1F0]

        var tmpMessage: Data = message

        // Step 1. Append Padding Bits
        tmpMessage.append([0x80]) // append one bit (Byte with one bit) to message

        // append "0" bit until message length in bits ≡ 448 (mod 512)
        while tmpMessage.count % length != (length - 8) {
            tmpMessage.append([0x00])
        }

        // hash values
        var mutableHash = hash

        // append message length, in a 64-bit big-endian integer. So now the message length is a multiple of 512 bits.
        tmpMessage.append((message.count * 8).bytes(64 / 8))

        // Process the message in successive 512-bit chunks:
        let chunkSizeBytes = 512 / 8 // 64
        var leftMessageBytes = tmpMessage.count
        var i = 0
        while i < tmpMessage.count {
            let chunk = tmpMessage.subdata(in: i ..< i + min(chunkSizeBytes, leftMessageBytes))
            // break chunk into sixteen 32-bit words M[j], 0 ≤ j ≤ 15, big-endian
            // Extend the sixteen 32-bit words into eighty 32-bit words:
            var M = [UInt32](repeating: 0, count: 80)
            for x in 0 ..< M.count {
                switch x {
                case 0 ... 15:
                    var le: UInt32 = 0
                    let range = NSRange(location: x * MemoryLayout<UInt32>.size, length: MemoryLayout<UInt32>.size)
                    (chunk as NSData).getBytes(&le, range: range)
                    M[x] = le.bigEndian
                default:
                    M[x] = rotateLeft(M[x - 3] ^ M[x - 8] ^ M[x - 14] ^ M[x - 16], n: 1)
                }
            }

            var A = mutableHash[0], B = mutableHash[1], C = mutableHash[2], D = mutableHash[3], E = mutableHash[4]

            // Main loop
            for j in 0 ... 79 {
                var f: UInt32 = 0
                var k: UInt32 = 0

                switch j {
                case 0 ... 19:
                    f = (B & C) | ((~B) & D)
                    k = 0x5A82_7999
                case 20 ... 39:
                    f = B ^ C ^ D
                    k = 0x6ED9_EBA1
                case 40 ... 59:
                    f = (B & C) | (B & D) | (C & D)
                    k = 0x8F1B_BCDC
                case 60 ... 79:
                    f = B ^ C ^ D
                    k = 0xCA62_C1D6
                default:
                    break
                }

                let temp = (rotateLeft(A, n: 5) &+ f &+ E &+ M[j] &+ k) & 0xFFFF_FFFF
                E = D
                D = C
                C = rotateLeft(B, n: 30)
                B = A
                A = temp
            }

            mutableHash[0] = (mutableHash[0] &+ A) & 0xFFFF_FFFF
            mutableHash[1] = (mutableHash[1] &+ B) & 0xFFFF_FFFF
            mutableHash[2] = (mutableHash[2] &+ C) & 0xFFFF_FFFF
            mutableHash[3] = (mutableHash[3] &+ D) & 0xFFFF_FFFF
            mutableHash[4] = (mutableHash[4] &+ E) & 0xFFFF_FFFF

            i = i + chunkSizeBytes
            leftMessageBytes -= chunkSizeBytes
        }

        // Produce the final hash value (big-endian) as a 160 bit number:
        let mutableBuff = NSMutableData()
        mutableHash.forEach {
            var i = $0.bigEndian
            mutableBuff.append(&i, length: MemoryLayout<UInt32>.size)
        }
        return mutableBuff as Data
    }
}

// swiftlint:enable all

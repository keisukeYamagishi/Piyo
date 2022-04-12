//
//  TwitterApiKey.swift
//  twit
//
//  Created by shichimi on 2017/03/20.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

/*
 * set Twitter Comsumer key and Comsumer secret
 * Brewtter App Token
 * https://apps.twitter.com/app/14638399
 */
import Foundation

public struct TwitterApi {
    public var key: String = ""
    public var secret: String = ""
}

open class TwitterKey {
    public static let shared = TwitterKey()
    public var api = TwitterApi()
    public var beareToken: String = ""

    private init() {}

    public func setBeareToken(data: Data) {
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                  let token = dictionary["access_token"]
            else {
                return
            }
            beareToken = token
        } catch {
            print(error)
        }
    }
}

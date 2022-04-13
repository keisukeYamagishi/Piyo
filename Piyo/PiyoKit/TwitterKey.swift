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

public class TwitterKey {
    public static let shared = TwitterKey()
    public var api = TwitterApi()
    public var user = TwiterUser()
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

    /*
     * set Twitter' user info
     *
     */
    public func setTwiAccount(data: Data) {
        guard let parameter = String(data: data, encoding: .utf8) else { return }
        setAccount(param: parameter.toDictionary)
    }

    private func setAccount(param: [String: String]) {
        user.screenName = param["screen_name"]!
        user.userId = param["user_id"]!
        user.oAuth.token = param["oauth_token"]!
        user.oAuth.secret = param["oauth_token_secret"]!
    }
}

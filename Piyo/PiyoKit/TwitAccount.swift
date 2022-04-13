//
//  TwitAccount.swift
//  twit
//
//  Created by shichimi on 2017/03/20.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
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

public struct TwiterUser {
    public var oAuth = OAuth()
    public var screenName = ""
    public var userId = ""
}

open class TwitAccount {
    public static let shared = TwitAccount()

    /*
     * member value
     *
     */
    public var twitter = TwiterUser()

    /*
     * initialize
     *
     */
    private init() {}

    /*
     * set Twitter' user info
     *
     */
    public func setTwiAccount(data: Data) {
        let parameter = String(data: data, encoding: .utf8)
        setAccount(param: (parameter?.toDictonary)!)
    }

    private func setAccount(param: [String: String]) {
        twitter.screenName = param["screen_name"]!
        twitter.userId = param["user_id"]!
        twitter.oAuth.token = param["oauth_token"]!
        twitter.oAuth.secret = param["oauth_token_secret"]!
    }
}

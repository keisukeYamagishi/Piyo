//
//  ApiURL.swift
//  Piyo
//
//  Created by keisuke yamagishi on 2022/04/12.
//  Copyright © 2022 Shichimitoucarashi. All rights reserved.
//

import Foundation

enum ApiURL {
    static let oAuthUrl = "https://api.twitter.com/oauth/request_token"
    static let oAuthAuthorize = "https://api.twitter.com/oauth/authorize?oauth_token="
    static let accessToken = "https://api.twitter.com/oauth/access_token"
    static let beareToken = "https://api.twitter.com/oauth2/token"
}

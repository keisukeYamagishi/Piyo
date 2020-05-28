//
//  ApiURL.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/28.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import Foundation

struct ApiURL {
    static let urlScheme = InfoPlist.callBackUrl
    static let oAuthUrl = "https://api.twitter.com/oauth/request_token"
    static let oAuth2 = "https://api.twitter.com/oauth/authorize?oauth_token="
}

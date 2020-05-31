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
    static let accessToken = "https://api.twitter.com/oauth/access_token"
    static let user = "https://api.twitter.com/1.1/users/show.json"
    static let tweetWithMedia = "https://api.twitter.com/1.1/statuses/update_with_media.json"
    static let tweet = "https://api.twitter.com/1.1/statuses/update.json"
}

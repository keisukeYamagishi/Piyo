//
//  TwitterApi.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/28.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import UIKit
import Piyo

class TwitterApi {

    static func oAuth() {
        TwitterApi.oAuthRequestToken { data in
            TwitterApi.oAuthAuthorize(data: data)
        }
    }

    static func oAuthRequestToken(completion: @escaping (_ data: Data) -> Void) {
        guard let request = Piyo.oAuth(ApiURL.urlScheme) else { return }
        HttpClient.connect(request: request,
                        completion: { data in
                            completion(data)
        })
    }

    static func oAuthAuthorize(data: Data) {
        guard let url = Piyo.oAuthAuthorize(data) else { return }
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
    }

    static func access(token: String, completion: (() -> Void)? = nil) {
        guard let request = Piyo.accessToken(token) else { return }
        HttpClient.connect(request: request) { data in
                            TwitterKey.shared.setTwiAccount(data: data)
                            completion?()
        }
    }

    static func beare() {
        guard let request = Piyo.beare() else { return }
        HttpClient.connect(request: request) { data in
            Piyo.setBeareToken(data)
            let u = "https://api.twitter.com/1.1/search/tweets.json?q=nasa"
            guard let request = Request.create(url: u, method: "GET", header: Piyo.beareHeader) else { return }
            
            HttpClient.connect(request: request) { data in
                print("\(String(describing: String(data: data, encoding: .utf8)))")
            }
        }
    }

    static func user(completion: @escaping (_ user: Data) -> Void) {
        let url = ApiURL.user
        let param = ["user_id": TwitterKey.shared.user.userId]
        let query = param.encodedQuery(using: .utf8)
        let uri = url + (url.range(of: "?") != nil ? "&" : "?") + query
        guard let header: [String: String] = Piyo.auth(url: url,
                                                       method: .get,
                                                       param: param) else { return }

        guard let request = Request.create(url: uri,
                                           method: "GET",
                                           header: header) else { return }

        HttpClient.connect(request: request) { (data) in
            completion(data)
        }
    }

    static func tweetWithMedia(tweet: String) {
        guard let request = Request.tweetWithMedia(url: ApiURL.tweetWithMedia,
                                          tweet: "Piyo🐦 Piyo🐦.\n A lightweight Twitter OAuth library🐦\nhttps://github.com/keisukeYamagishi/Piyo",
                                          img: UIImage(named: "shichimi.png")!) else { return }
        HttpClient.connect(request: request)
    }
}

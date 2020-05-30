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

    static func oAuthRequestToken(completion: @escaping (_ data: Data) -> Void){

        guard let authHeader = Piyo.auth(url: ApiURL.oAuthUrl,
                                         method: .post,
                                         param: ["oauth_callback": ApiURL.urlScheme]) else {
                                            return
        }

        guard let request = Request.create(url: ApiURL.oAuthUrl,
                                           method: "POST",
                                           header: authHeader) else { return }

        HttpClient.connect(request: request,
                        completion: { data in
                            completion(data)
        })
    }

    static func oAuthAuthorize(data: Data) {
        let responseData = String(data: data, encoding: .utf8)
        let attributes = responseData?.queryStringParameters

        if let attrbute = attributes?["oauth_token"] {
            let url: String = ApiURL.oAuth2 + attrbute
            let queryURL = URL(string: url)!
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(queryURL, options: [:])
                } else {
                    UIApplication.shared.openURL(queryURL)
                }
            }
        }
    }

    static func access(token: String, completion: (() -> Void)? = nil){
        let url = ApiURL.accessToken
        guard let header = Piyo.auth(url: url, method: .post, param: token.queryStringParameters) else { return }
        guard let request = Request.create(url: url, method: "POST", header: header) else { return }

        HttpClient.connect(request: request) { data in
                            TwitAccount.shared.setTwiAccount(data: data)
                            completion?()
        }
    }

    static func user(completion: @escaping (_ user: Data) -> Void){
        let url = ApiURL.user
        let param = ["user_id": TwitAccount.shared.twitter.userId]
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
    
    static func tweet(tweet: String, comp: @escaping () -> Void) {        
        guard let request = Request.tweet(url: ApiURL.tweet,
                                          tweet: "Hi! Tweet",
                                          img: UIImage(named: "download.png")!) else { return }
        HttpClient.connect(request: request)
    }
}

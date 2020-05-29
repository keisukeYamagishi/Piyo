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
        HttpClient.http(url: ApiURL.oAuthUrl,
                        method: "POST",
                        header: Twitter.authorize(url: ApiURL.oAuthUrl,
                                                  param: ["oauth_callback":ApiURL.urlScheme]),
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
        HttpClient.http(url: url,
                        method: "POST",
                        header: Twitter.authorize(url: url, param: token.queryStringParameters)) { data in
                            TwitAccount.shared.setTwiAccount(data: data)
                            completion?()
        }
    }
//    
//    static func tweet(tweet: String, comp: @escaping (String) -> Void){
//        let url = "https://api.twitter.com/1.1/statuses/update.json"
//        let header: [String: String] = ["Authorization": Twitter.signature(url: url, method: "POST", param: ["status" : tweet])]
//        HttpClient.http(url: url, method: "POST", header: header) { (data) in
//            comp(String(data: data, encoding: .utf8)!)
//        }
//    }

    static func user(completion: @escaping (_ user: Data) -> Void){
        let url = ApiURL.user
        let param = ["user_id": TwitAccount.shared.twitter.userId]
        let query = param.encodedQuery(using: .utf8)
        let uri = url + (url.range(of: "?") != nil ? "&" : "?") + query

        let header: [String: String] = ["Authorization": Twitter.signature(url: url,
                                                                        method: "GET",
                                                                        param: param,
                                                                        isUpload: false),
                                        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
        HttpClient.http(url: uri,  method: "GET", header: header) { (data) in
            completion(data)
        }
    }
}

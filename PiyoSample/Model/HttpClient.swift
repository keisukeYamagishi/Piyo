//
//  HttpClient.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/26.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import UIKit
import Piyo

struct ApiURL {
    static let urlScheme = InfoPlist.callBackUrl
    static let oAuthUrl = "https://api.twitter.com/oauth/request_token"
    static let oAuth2 = "https://api.twitter.com/oauth/authorize?oauth_token="    
}

class HttpClient {
    
    func oAuth(){
        HttpClient.http(url: ApiURL.oAuthUrl,
                        method: "POST",
                        header: Twitter.authorize(url: ApiURL.oAuthUrl,
                                                  param: ["oauth_callback":ApiURL.urlScheme]),
                        completion: { data in
                            self.oAuth2(data: data)
        })
    }
    
    func oAuth2(data: Data) {
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

    func access(token: String){
        let url = "https://api.twitter.com/oauth/access_token"
        
        HttpClient.http(url: url, method: "POST", header: Twitter.authorize(url: url, param: token.queryStringParameters)) { data in
//            if (responce?.statusCode)! < 300 {
                TwitAccount.shared.setTwiAccount(data: data)
//                success(TwitAccount.shared.twitter)
//            }
        }
    }
    
    func tweet(tweet: String, comp: @escaping (String) -> Void){
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        let header: [String: String] = ["Authorization": Twitter.signature(url: url, method: "POST", param: ["status" : tweet])]
        HttpClient.http(url: url, method: "POST", header: header) { (data) in
            comp(String(data: data, encoding: .utf8)!)
        }
    }

    static func http(url: String,
                     method: String,
                     header: [String:String]? = nil,
                     completion: ((Data) -> Void)? = nil) {
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method
        for (key, value) in header ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }

        let task = URLSession.shared.dataTask(with: request) { (data, responce, error) in
            // ここのエラーはクライアントサイドのエラー(ホストに接続できないなど)
            if let error = error {
                print("クライアントエラー: \(error.localizedDescription) \n")
                return
            }

            guard let data = data, let response = responce as? HTTPURLResponse else {
                print("no data or no response")
                return
            }

            print("Responcce: \(response)")
            if response.statusCode == 200 {
                print(data)
                completion?(data)
            } else {
                // レスポンスのステータスコードが200でない場合などはサーバサイドエラー
                print("サーバエラー ステータスコード: \(response.statusCode)\n")
            }

        }
        task.resume()
    }
}

//
//  HttpClient.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/26.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import UIKit
import Piyo

class HttpClient {

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

//
//  Twitter.swift
//  HttpSessionSample
//
//  Created by Shichimitoucarashi on 2018/04/28.
//  Copyright © 2018年 keisuke yamagishi. All rights reserved.
//

import UIKit

open class Piyo {

    /*
     * Http method
     */
    public enum Method: String {
        case get  = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case connect = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
    }

    /*
    * Authenticate:
    * Header: Authorization request token
    */
    static public func auth(url: String,
                            method: Method,
                            param: [String: String],
                            upload: Bool = false) -> [String: String]? {

        guard let signature = Piyo.signature(url: url,
                                             method: method,
                                             param: param,
                                             upload: upload) else {
            return nil
        }
        return ["Authorization": signature]
    }

    /*
    * Authenticate: Access token
    * Header: Authorization acccess token
    *
    */
    static public func signature(url: String,
                                 method: Method,
                                 param: [String: String],
                                 upload: Bool = false) -> String? {
        do {
            return try OAuthKit.authorizationHeader(for: url.toURL(),
                                                    method: method.rawValue,
                                                    param: param,
                                                    isMediaUpload: upload)
        } catch {
            print("Exception: \(error)")
        }
        return nil
    }

    public static func beare() -> URLRequest? {
        let url = ApiURL.beareToken
        let credential = URI.credentials
        let header: [String: String] = ["Authorization": "Basic " + credential,
                                        "Content-Type": "application/x-www-form-urlencoded; charset=utf8"]
        let parameter = ["grant_type": "client_credentials"]
        return Request.create(url: url, header: header, parameter: parameter)
    }

    /*
     * Authenticate: Bearer
     * Header: Authorization Bearer
     * Twitter Followe list
     *
     */
    @inlinable
    public static var beareHeader: [String: String] {
        ["Authorization": "Bearer " + TwitterKey.shared.beareToken]
    }

    public static func setBeareToken(_ data: Data) {
        TwitterKey.shared.setBeareToken(data: data)
    }
}

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
        case get = "GET"
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
    public static func auth(url: String,
                            method: Method,
                            param: [String: String],
                            upload: Bool = false) -> [String: String]?
    {
        guard let signature = Piyo.signature(url: url,
                                             method: method,
                                             param: param,
                                             upload: upload)
        else {
            return nil
        }
        return ["Authorization": signature]
    }

    /*
     * Authenticate: Access token
     * Header: Authorization acccess token
     *
     */
    public static func signature(url: String,
                                 method: Method,
                                 param: [String: String],
                                 upload: Bool = false) -> String?
    {
        do {
            return try OAuthKit.authorizationHeader(for: url.toURL(),
                                                    method: method.rawValue,
                                                    param: param,
                                                    isMediaUpload: upload)
        } catch {
            print(error)
        }
        return nil
    }

    /*
     * Authenticate: Access token
     * Header: Authorization Access token
     */
    public static func oAuth(_ urlScheme: String) -> URLRequest? {
        guard let authHeader = Piyo.auth(url: ApiURL.oAuthUrl,
                                         method: .post,
                                         param: ["oauth_callback": urlScheme]) else { return nil }

        return Request.create(url: ApiURL.oAuthUrl,
                              header: authHeader)
    }

    /*
     * Authenticate: Access token
     * Header: oAuth Authorize Twitter login url
     */
    public static func oAuthAuthorize(_ data: Data) -> URL? {
        let responseData = String(data: data, encoding: .utf8)
        let attributes = responseData?.toDictonary

        guard let attribute = attributes?["oauth_token"] else { return nil }
        let url = ApiURL.oAuthAuthorize + attribute
        guard let queryURL = URL(string: url) else { return nil }
        return queryURL
    }

    /*
     * Authenticate: Access token
     * Header: oAuth Authorize
     * Access Token request
     */
    public static func accessToken(_ token: String) -> URLRequest? {
        let url = ApiURL.accessToken
        guard let header = Piyo.auth(url: url,
                                     method: .post,
                                     param: token.toDictonary) else { return nil }
        guard let request = Request.create(url: url,
                                           header: header) else { return nil }
        return request
    }

    /*
     * Authenticate: Bearer
     * Header: Authorization Bearer token request
     */
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
     * Twitter
     *
     */
    @inlinable
    public static var beareHeader: [String: String] {
        ["Authorization": "Bearer " + TwitterKey.shared.beareToken]
    }

    /*
     * Authenticate: Bearer
     * Header: Set Authorization Bearer
     * Twitter
     *
     */
    public static func setBeareToken(_ data: Data) {
        TwitterKey.shared.setBeareToken(data: data)
    }
}

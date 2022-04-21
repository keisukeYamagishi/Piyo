//
//  OAuthKit.swift
//  twit
//
//  Created by shichimi on 2017/03/19.
//  Copyright © 2017年 shichimitoucarashi. All rights reserved.
//

import Foundation

enum OAuthKit {
    @frozen
    enum OAuth {
        static let version = "1.0"
        static let signatureMethod = "HMAC-SHA1"
    }

    /*
     * create headers
     *
     *
     */
    @inlinable
    public static func authorizationHeader(for url: URL,
                                           method: String,
                                           parameters: [String: Any],
                                           isMediaUpload: Bool) -> String
    {
        var authorization: [String: Any] = [:]
        authorization["oauth_version"] = OAuth.version
        authorization["oauth_signature_method"] = OAuth.signatureMethod
        authorization["oauth_consumer_key"] = TwitterKey.shared.api.key
        authorization["oauth_timestamp"] = String(Int(Date().timeIntervalSince1970))
        authorization["oauth_nonce"] = UUID().uuidString

        authorization["oauth_token"] ??= TwitterKey.shared.user.oAuth.token

        for (key, value) in parameters where key.hasPrefix("oauth_") {
            authorization.updateValue(value, forKey: key)
        }

        let combinedParameters = authorization +| parameters

        let final = isMediaUpload ? authorization : combinedParameters

        authorization["oauth_signature"] = oAuthSignature(for: url, method: method, parameters: final)

        let authorizationParameter = authorization.encodedQuery(using: .utf8)
        let authorizationParameterComponents = authorizationParameter.components(separatedBy: "&").sorted()

        var headerComponents = [String]()
        for component in authorizationParameterComponents {
            let subcomponent = component.components(separatedBy: "=")
            if subcomponent.count == 2 {
                headerComponents.append("\(subcomponent[0])=\"\(subcomponent[1])\"")
            }
        }
        return "OAuth " + headerComponents.joined(separator: ", ")
    }

    /*
     * OAuth signature
     * create signature value
     *
     */
    @inlinable
    static func oAuthSignature(for url: URL,
                               method: String,
                               parameters: [String: Any]) -> String
    {
        let tokenSecret = TwitterKey.shared.user.oAuth.secret
        let encodedConsumerSecret = TwitterKey.shared.api.secret.percentEncode()
        let signingKey = "\(encodedConsumerSecret)&\(tokenSecret)"
        let parameterComponents = parameters.encodedQuery(using: .utf8).components(separatedBy: "&").sorted()
        let parameterString = parameterComponents.joined(separator: "&")
        let encodedParameterString = parameterString.percentEncode()
        let encodedURL = url.absoluteString.percentEncode()
        let signatureBaseString = "\(method)&\(encodedURL)&\(encodedParameterString)"
        let key = signingKey.data(using: .utf8)!
        let msg = signatureBaseString.data(using: .utf8)!
        let sha1 = HMAC.sha1(key: key, message: msg)!
        return sha1.base64EncodedString(options: [])
    }
}

//
//  InfoPlistOperator.swift
//  PiyoSample
//
//  Created by Shichimitoucarashi on 2020/05/27.
//  Copyright © 2020 Shichimitoucarashi. All rights reserved.
//

import Foundation

class InfoPlist {

    static let urlScheme: String? = {
        let infoPlist = Bundle.main.infoDictionary
        guard let urlType: [Any] = infoPlist?["CFBundleURLTypes"] as? [Any] else { return nil }
        guard let items: [String: AnyObject] = urlType[0] as? [String: AnyObject] else { return nil }
        guard let urlSchemes: [String] = items["CFBundleURLSchemes"] as? [String]  else { return nil }
        if let urlScheme = urlSchemes.first {
            return urlScheme
        }
        return nil
    }()

    static let callBackUrl: String = {
        if let urlScheme: String = InfoPlist.urlScheme as String? {
            return urlScheme + "://"
        }
        return ""
    }()
}

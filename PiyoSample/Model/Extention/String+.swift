//
//  String+.swift
//  PiyoSample
//
//  Created by keisuke yamagishi on 2022/04/26.
//  Copyright © 2022 Shichimitoucarashi. All rights reserved.
//

import Foundation

extension String {
    func encode(_ parameter: [String: String]) -> String {
        parameter.map { "\($0)=\($1.percentEncode())" }.joined(separator: "&")
    }
}

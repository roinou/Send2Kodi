//
//  KodiConfig.swift
//  SKR
//
//  Created by Erwan Lacoste on 01/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import Foundation

struct KodiConfig {
    var host: String
    var port: Int
    
    static let `default` = Self(host: "osmc.loc", port: 808)
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
}

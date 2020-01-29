//
//  LMSConfig.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 29/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

struct LMSConfig {
    var host: String
    var port: Int
    var player: String
    
    static let `default` = Self(host: "lms.loc", port: 90, player: "player")
    
    init(host: String, port: Int, player: String) {
        self.host = host
        self.port = port
        self.player = player
    }
}

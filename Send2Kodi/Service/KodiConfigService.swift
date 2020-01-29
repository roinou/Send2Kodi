//
//  KodiConfigService.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 24/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import Foundation

class KodiConfigService: ObservableObject {
    private enum Keys {
        static let host = "host"
        static let port = "port"
    }

    private let defaults: UserDefaults

    init(_ defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            Keys.host: "osmc.local",
            Keys.port: 8080
        ])
    }
    
    func update(_ config: KodiConfig) {
        self.host = config.host
        self.port = config.port
    }
    func read() -> KodiConfig {
        return KodiConfig(host: self.host, port: self.port)
    }

    var host: String {
        set { defaults.set(newValue, forKey: Keys.host) }
        get { defaults.string(forKey: Keys.host)! }
    }

    var port: Int {
        set {
//            print("setting port: \(newValue)")
            defaults.set(newValue, forKey: Keys.port) }
        get {
            let ret = defaults.integer(forKey: Keys.port)
//            print("port is \(ret)")
            return ret
        }
    }
}

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
        static let lmsHost = "lms.host"
        static let lmsPort = "lms.port"
        static let lmsPlayer = "lms.player"
    }

    private let defaults: UserDefaults

    init(_ defaults: UserDefaults = .standard) {
        self.defaults = defaults
        
        defaults.register(defaults: [
            Keys.host: "osmc.local",
            Keys.port: 8080,
            Keys.lmsHost: "lms.local",
            Keys.lmsPort: "9000",
            Keys.lmsPlayer: "player"
        ])
    }
    
    func update(_ config: KodiConfig) {
        self.host = config.host
        self.port = config.port
    }
    func update(_ config: LMSConfig) {
        self.lmsHost = config.host
        self.lmsPort = config.port
        self.lmsPlayer = config.player
    }
    
    func read() -> KodiConfig {
        return KodiConfig(host: self.host, port: self.port)
    }
    func read() -> LMSConfig {
        return LMSConfig(host: self.lmsHost, port: self.lmsPort, player: self.lmsPlayer)
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
    
    var lmsHost: String {
        set { defaults.set(newValue, forKey: Keys.lmsHost) }
        get { defaults.string(forKey: Keys.lmsHost)! }
    }
    var lmsPort: Int {
        set { defaults.set(newValue, forKey: Keys.port) }
        get { defaults.integer(forKey: Keys.port) }
    }
    var lmsPlayer: String {
        set { defaults.set(newValue, forKey: Keys.lmsPlayer) }
        get { defaults.string(forKey: Keys.lmsPlayer)! }
    }
}

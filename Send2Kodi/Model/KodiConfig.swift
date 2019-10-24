//
//  KodiConfig.swift
//  SKR
//
//  Created by Erwan Lacoste on 01/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import SwiftUI
import Combine

final class KodiConfig: ObservableObject {
//    @Published var host: String = "osmc.local"
//    @Published<Int> var port: Int = 80
    
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

    var host: String {
        set { defaults.set(newValue, forKey: Keys.host) }
        get { defaults.string(forKey: Keys.host)! }
    }

    var port: Int {
        set {
            print("setting port: \(newValue)")
            defaults.set(newValue, forKey: Keys.port) }
        get { defaults.integer(forKey: Keys.port) }
    }
}

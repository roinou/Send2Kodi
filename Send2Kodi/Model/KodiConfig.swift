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
    @Published var host: String = "osmc.local"
    @Published<Int> var port: Int = 80
}

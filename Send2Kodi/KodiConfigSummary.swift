//
//  KodiConfigSummary.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 24/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import SwiftUI

struct KodiConfigSummary: View {
    
    var config: KodiConfig
    
    @EnvironmentObject var service: KodiService
    
    var body: some View {
        VStack {
            Text(verbatim: "\(config.host):\(config.port)")
            Divider()
            Button(action: {
                self.service.notificationTest()
            }) {
                Text("Test")
            }
        }
    }
}

struct KodiConfigSummary_Previews: PreviewProvider {
    static var previews: some View {
        KodiConfigSummary(config: .default)
    }
}

//
//  ContentView.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 11/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import SwiftUI

struct ContentView: View {
 
    @EnvironmentObject var config: KodiConfig
    
    @EnvironmentObject var service: KodiService
    
    var body: some View {
        VStack() {
            Text("Kodi Settings")
                .font(.title)
                .fontWeight(.medium)
            Divider()
            HStack() {
                Text("Host")
                TextField("Host", text: $config.host)
            }
            Divider()
            HStack() {
                Text("Port")
                TextField("0", value: $config.port, formatter: NumberFormatter())
            }
            Divider()
            Button(action: {
                self.service.test()
            }) {
                Text("Test")
            }
            Spacer()
        }
        .padding(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let conf = KodiConfig()
        return ContentView()
            .environmentObject(conf)
            .environmentObject(KodiService(config: conf))
    }
}

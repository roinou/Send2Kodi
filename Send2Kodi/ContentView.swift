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
        
        // proxy the text field String to allow on-the-fly set
        let portProxy = Binding<String>(
            get: { "\(self.config.port)" },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.config.port = value.intValue
                }
            }
        )
        
        return VStack() {
            Text(verbatim: "Kodi Settings")
                .font(.title)
                .fontWeight(.medium)
            Divider()
            HStack() {
//                Text("Host")
                TextField("Host", text: $config.host)
            }
            Divider()
            HStack() {
//                Text("Port")
                TextField("Port", text: portProxy)
                    .keyboardType(.asciiCapableNumberPad)
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

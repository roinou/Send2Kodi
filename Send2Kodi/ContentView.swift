//
//  ContentView.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 11/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import SwiftUI

struct ContentView: View {
 
        //@State private var config = KodiConfig(host: "osmc.local", port: 8080)
        @EnvironmentObject var config: KodiConfig
        
        var body: some View {
            VStack() {
                Text("Kodi Settings")
                    .font(.title)
                    .fontWeight(.medium)
                Divider()
                HStack() {
                    Text("Host")
    //                Spacer()
                    TextField("Host", text: $config.host)
                }
                Divider()
                HStack() {
                    Text("Port")
    //                Spacer()
                    TextField("0", value: $config.port, formatter: NumberFormatter())
                }
                Divider()
                Spacer()
            }
            .padding(.all)
        }
    }

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
                .environmentObject(KodiConfig())
        }
}

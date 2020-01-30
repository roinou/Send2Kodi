//
//  LMSView.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 29/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import SwiftUI

struct LMSView: View {
    
    @EnvironmentObject var config: ConfigService
    @EnvironmentObject var service: LMSService
    @Environment(\.editMode) var mode
    
    @Binding var draftConfig: LMSConfig
    
    var body: some View {
        // proxy the text field String to allow on-the-fly set
        let portProxy = Binding<String>(
            get: { "\(self.draftConfig.port)" },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    self.draftConfig.port = value.intValue
                }
            }
        )
        
        return VStack() {
            Text(verbatim: "LMS Settings")
                .font(.title)
                .fontWeight(.medium)
            Divider()
            if self.mode?.wrappedValue == .inactive {
                VStack {
                    Text(verbatim: "\(self.draftConfig.host):\(self.draftConfig.port)?player=\(self.draftConfig.player)")
                    Divider()
                }
            } else {
                VStack() {
                    HStack() {
                        Text("Host")
                        TextField("Host", text: $draftConfig.host)
                    }
                    Divider()
                    HStack() {
                        Text("Port")
                        TextField("Port", text: portProxy)
                            .keyboardType(.asciiCapableNumberPad)
                    }
                    Divider()
                    HStack() {
                        Text("Player")
                        TextField("Player", text: $draftConfig.player)
                    }
                    Divider()
                }
                .padding(.all)
                .onAppear {
                    self.draftConfig = self.config.read()
                }
                .onDisappear {
                    self.config.update(self.draftConfig)
                }
            }
        }
    }
}

struct LMSView_Previews: PreviewProvider {
    static var previews: some View {
        LMSView(draftConfig: .constant(.default))
    }
}

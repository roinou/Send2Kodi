//
//  ContentView.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 11/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import SwiftUI

struct ContentView: View {
 
    @Environment(\.editMode) var mode
    @EnvironmentObject var config: KodiConfigService
    
    @State var draftConfig = KodiConfig.default
    
    @State var currentConfig: KodiConfig
    
    var body: some View {
        return VStack() {
            HStack() {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftConfig = self.config.read()
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            Text(verbatim: "Kodi Settings")
                .font(.title)
                .fontWeight(.medium)
            Divider()
            if self.mode?.wrappedValue == .inactive {
                KodiConfigSummary(config: currentConfig)
            } else {
                KodiConfigEditor(config: $draftConfig)
                    .onAppear {
                        self.draftConfig = self.config.read()
                    }
                    .onDisappear {
                        self.currentConfig = self.draftConfig
                        self.config.update(self.draftConfig)
                    }
            }
            Spacer()
        }
        .padding(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let conf = KodiConfigService()
        return ContentView(currentConfig: .default)
            .environmentObject(conf)
    }
}

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
    
    @State var draftKodiConfig = KodiConfig.default
    @State var draftLMSConfig = LMSConfig.default
    
    var body: some View {
        return VStack() {
            HStack() {
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftKodiConfig = self.config.read()
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            KodiView(draftConfig: $draftKodiConfig)
            Divider()
            LMSView(draftConfig: $draftLMSConfig)
            Spacer()
        }
        .padding(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let conf = KodiConfigService()
        return ContentView(draftKodiConfig: .default, draftLMSConfig: .default)
            .environmentObject(conf)
    }
}

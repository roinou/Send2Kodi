//
//  KodiView.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 29/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import SwiftUI

struct KodiView: View {
    
    @EnvironmentObject var config: ConfigService
    @Environment(\.editMode) var mode
    
    @Binding var draftConfig: KodiConfig
    
    var body: some View {
        return VStack() {
            Text(verbatim: "Kodi Settings")
                .font(.title)
                .fontWeight(.medium)
            Divider()
            if self.mode?.wrappedValue == .inactive {
                KodiConfigSummary(config: draftConfig)
            } else {
                KodiConfigEditor(config: $draftConfig)
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

struct KodiView_Previews: PreviewProvider {
    static var previews: some View {
        KodiView(draftConfig: .constant(.default))
            .environmentObject(ConfigService())
    }
}

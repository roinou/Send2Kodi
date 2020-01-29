//
//  KodiConfigEditor.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 24/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import SwiftUI

struct KodiConfigEditor: View {
    
    @Binding var config: KodiConfig
    
    var body: some View {
        
        // proxy the text field String to allow on-the-fly set
        let portProxy = Binding<String>(
            get: {
                print("proxy get \(self.config.port)")
                return "\(self.config.port)" },
            set: {
                print("proxy set \($0)")
                if let value = NumberFormatter().number(from: $0) {
                    self.config.port = value.intValue
                }
            }
        )
        
        return VStack() {
            HStack() {
                Text("Host")
                TextField("Host", text: $config.host)
            }
            Divider()
            HStack() {
                Text("Port")
                TextField("Port", text: portProxy)
                    .keyboardType(.asciiCapableNumberPad)
            }
            Divider()
        }
        .padding(.all)
    }
}

struct KodiConfigEditor_Preview: PreviewProvider {
    static var previews: some View {
        return KodiConfigEditor(config: .constant(.default))
    }
}

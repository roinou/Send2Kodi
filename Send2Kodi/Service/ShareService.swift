//
//  ShareService.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 30/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

/// service that shares a Youtube ID with a given system.
protocol ShareService: YoutubeIDExtract {
    
    /// Send the given Youtube ID our URL to the target system
    /// - Parameter idOrUrl: either a valid Youtube ID, or a URL containing this ID (cf YoutubeIDExtract).
    func send(_ idOrUrl: String)
    
    func performCall(id: String)
}

extension ShareService {
    
    func send(_ idOrUrl: String) {
        if let youtubeId = self.extractYoutubeId(idOrUrl) {
            self.performCall(id: youtubeId)
        }
    }
}

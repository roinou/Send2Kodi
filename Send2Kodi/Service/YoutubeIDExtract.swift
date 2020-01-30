//
//  YoutubeIDExtract.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 30/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import Foundation

protocol YoutubeIDExtract {
    func extractYoutubeId(_ url: String) -> String?
}

extension YoutubeIDExtract {
 
    func extractYoutubeId(_ url: String) -> String? {
        // either https://youtu.be/z29x-ZjtXfY or https://www.youtube.com/watch?v=z29x-ZjtXfY&feature=share
        let regex = try! NSRegularExpression(pattern: "(https://(.*\\.)?yout.*/(watch\\?v=)?)?(?<id>[^&/]+)(\\&.*)?")
        let matches = regex.matches(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count))
        if let match = matches.first {
            if let swiftRange = Range(match.range(withName: "id"), in: url) {
                return String(url[swiftRange])
            }
        }
        return nil
    }
}

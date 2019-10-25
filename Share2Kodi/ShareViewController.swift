//
//  ShareViewController.swift
//  Share2Kodi
//
//  Created by Erwan Lacoste on 25/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = "public.plain-text"
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (item, error) in
                let youtubeUrl = item as! String
                if let youtubeId = self.extractYoutubeId(youtubeUrl) {
                    self.send2kodi(id: youtubeId)
                }
            })
        }

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    func kodiUrl() -> URL {
        let settings = self.loadSettings()
        let url = "http://\(settings.host):\(settings.port)/jsonrpc"
        guard
            let ret = URL(string: url)
        else { preconditionFailure("Can't create url components \(url)") }
        return ret
    }
    
    func send2kodi(id: String) {
        let url = kodiUrl()
        print("sending \(id) to \(url)")
        
        let fileUrl = "plugin://plugin.video.youtube/?action=play_video&videoid=\(id)"
        var req = URLRequest(url: url)
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                req.httpMethod = "POST"
                
                let json: [String: Any] = [
                    "jsonrpc": "2.0",
                    "method": "Player.Open",
                    "params": [
                        "item": [
                            "file": fileUrl
                        ]
                    ],
                    "id":1
                ]
                let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
                
                let task = URLSession.shared.uploadTask(with: req, from: jsonData) { (data, res, err) in
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        print("success")
                        print(dataString)
                    } else if let error = err {
                        print("error")
                        print(error)
                    }
                }
                task.resume()
    }

    func loadSettings() -> (host: String, port: Int) {
        let def = UserDefaults(suiteName: "group.be.vershina.Send2Kodi") ?? .standard
        let host = def.string(forKey: "host") ?? ""
        let port = def.integer(forKey: "port")
        return (host, port)
    }
    
    func extractYoutubeId(_ url: String) -> String? {
        // either https://youtu.be/z29x-ZjtXfY or https://www.youtube.com/watch?v=z29x-ZjtXfY&feature=share
        let regex = try! NSRegularExpression(pattern: ".*/(watch\\?v=)?([^&/]*)(\\&.*)?")
        let matches = regex.matches(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count))
        if let match = matches.first {
            if let swiftRange = Range(match.range(at:2), in: url) {
                return String(url[swiftRange])
            }
        }
        return nil
    }
}

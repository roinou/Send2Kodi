//
//  KodiService.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 12/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import Foundation

class KodiService: ObservableObject, YoutubeIDExtract, ShareService {

    let config: ConfigService
    
    private let session: URLSession
    private let decoder: JSONDecoder

    init(config: ConfigService, session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
        
        self.config = config
    }

    func kodiUrl() -> URL {
        let url = "http://\(self.config.host):\(self.config.port)/jsonrpc"
        guard
            let ret = URL(string: url)
        else { preconditionFailure("Can't create url components \(url)") }
        return ret
    }
    
    /// calls the ShowNotification method
    func notificationTest() {
        var req = URLRequest(url: kodiUrl())
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpMethod = "POST"
        
//        {"jsonrpc": "2.0","method": "Input.SendText","params":{"text": "It's allright Mama","done": false},"id":0}
        let json: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "GUI.ShowNotification",
            "params": [
                "title": "Send2Kodi",
                "message": "It's allright Mama"
            ],
            "id":0
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        let task = self.session.uploadTask(with: req, from: jsonData) { (data, res, err) in
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
    
    func performCall(id: String) {
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
        
        let task = self.session.uploadTask(with: req, from: jsonData) { (data, res, err) in
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
}

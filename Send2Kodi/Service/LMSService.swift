//
//  LMSService.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 29/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import Foundation

class LMSService: ObservableObject, YoutubeIDExtract {
   
    let config: ConfigService
    
    private let session: URLSession

    init(config: ConfigService, session: URLSession = .shared) {
        self.session = session
        self.config = config
    }

    func generateUrl() -> URL {
        let url = "http://\(self.config.lmsHost):\(self.config.lmsPort)/status.html"
        guard
            let ret = URL(string: url)
        else { preconditionFailure("Can't create url components \(url)") }
        return ret
    }
    
    func send(_ id: String) {
        let queryItems = [
            URLQueryItem(name: "p0", value: "playlist"),
            URLQueryItem(name: "p1", value: "play"),
            URLQueryItem(name: "p2", value: "youtube://\(id)"),
            URLQueryItem(name: "player", value: self.config.lmsPlayer)]
        let urlComps = NSURLComponents(string: "http://\(self.config.lmsHost):\(self.config.lmsPort)/status.html")!
        urlComps.queryItems = queryItems
        let url = urlComps.url!
        print("calling \(url)")
        
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        
        let task = self.session.dataTask(with: req) { (data, res, err) in
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

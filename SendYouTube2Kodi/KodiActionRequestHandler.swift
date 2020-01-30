//
//  KodiActionRequestHandler.swift
//  Send2Kodi
//
//  Created by Erwan Lacoste on 30/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import UIKit
import MobileCoreServices

class KodiActionRequestHandler: NSObject, NSExtensionRequestHandling, ActionRequestHandler {

    var extensionContext: NSExtensionContext?

    func initService(config: ConfigService) -> ShareService {
        return KodiService.init(config: config)
    }

    func beginRequest(with context: NSExtensionContext) {
        self.doBeginRequest(with: context)
    }
}

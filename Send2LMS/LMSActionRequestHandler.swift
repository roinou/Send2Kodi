//
//  ActionRequestHandler.swift
//  Send2LMS
//
//  Created by Erwan Lacoste on 30/01/2020.
//  Copyright © 2020 Erwan Lacoste. All rights reserved.
//

import UIKit
import MobileCoreServices

class LMSActionRequestHandler: NSObject, NSExtensionRequestHandling, ActionRequestHandler {

    var extensionContext: NSExtensionContext?

    func initService(config: ConfigService) -> ShareService {
        return LMSService.init(config: config)
    }

    func beginRequest(with context: NSExtensionContext) {
        self.doBeginRequest(with: context)
    }
}

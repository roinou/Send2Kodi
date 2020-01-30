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
        let itemProvider = extensionItem.attachments?.first!
        if itemProvider?.hasItemConformingToTypeIdentifier("public.plain-text") ?? false {
            itemProvider?.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (item, error) in
                let userDefaults = UserDefaults(suiteName: "group.be.vershina.Send2Kodi2") ?? .standard
                let config = ConfigService(userDefaults)
                let kodiService = KodiService.init(config: config)
                
                kodiService.send(item! as! String)
            })
        }

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
}

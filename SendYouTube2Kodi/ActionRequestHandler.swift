//
//  ActionRequestHandler.swift
//  SendYouTube2Kodi
//
//  Created by Erwan Lacoste on 18/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionRequestHandler: NSObject, NSExtensionRequestHandling {

    var extensionContext: NSExtensionContext?
    
    func beginRequest(with context: NSExtensionContext) {
        // Do not call super in an Action extension with no user interface
        self.extensionContext = context
        
        var finished = false
        
        // Find the item containing the results from the JavaScript preprocessing.
        outer:
            for item in context.inputItems as! [NSExtensionItem] {
                if let attachments = item.attachments {
                    for itemProvider in attachments {
                        if itemProvider.hasItemConformingToTypeIdentifier("public.plain-text") {
                            itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (item, error) in
                                
                                let userDefaults = UserDefaults(suiteName: "group.be.vershina.Send2Kodi") ?? .standard
                                let config = KodiConfig(userDefaults)
                                let kodiService = KodiService.init(config: config)

                                if let youtubeId = kodiService.extractYoutubeId(item! as! String) {
                                    kodiService.send2kodi(id: youtubeId)
                                }
                            })
                            break outer
                        }
                        
                        if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
                            itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil, completionHandler: { (item, error) in
                                let dictionary = item as! [String: Any]
                                OperationQueue.main.addOperation {
                                    self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [String: Any]? ?? [:])
                                }
                            })
                            finished = true
                            break outer
                        }
                    }
                }
        }
        
        if !finished {
            self.finishIt()
        }
    }
    
    // Make sure you finish the job here!!
    func itemLoadCompletedWithPreprocessingResults(_ javaScriptPreprocessingResults: [String: Any]) {
        // Here, do something, potentially asynchronously, with the preprocessing
        // results.
        
        var stopPlayback = false
        // the JavaScript will have passed us the url
        if let url = javaScriptPreprocessingResults["currentUrl"] as! String? {
            print("processing send 2 kodi with url: \(url)")
            
            let userDefaults = UserDefaults(suiteName: "group.be.vershina.Send2Kodi") ?? .standard
            let config = KodiConfig(userDefaults)
            let kodiService = KodiService.init(config: config)

            if let youtubeId = kodiService.extractYoutubeId(url) {
                kodiService.send2kodi(id: youtubeId)
                // youtube URL, try to stop playback
                stopPlayback = true
            }
        }
        self.finishIt(stopPlayback: stopPlayback)
    }
    
    func finishIt(stopPlayback: Bool = false) {
        if (stopPlayback) {
            // let's callback javascript to try to stop the playback
            let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: true]
            
            let resultsProvider = NSItemProvider(item: resultsDictionary as NSDictionary, typeIdentifier: String(kUTTypePropertyList))
            
            let resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            
            // Signal that we're complete, returning our results.
            self.extensionContext!.completeRequest(returningItems: [resultsItem], completionHandler: nil)
        } else {
            // We still need to signal that we're done even if we have nothing to
            // pass back.
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
        // Don't hold on to this after we finished with it.
        self.extensionContext = nil
    }
    
    func doneWithResults(_ resultsForJavaScriptFinalizeArg: [String: Any]?) {
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            // Construct an NSExtensionItem of the appropriate type to return our
            // results dictionary in.
            
            // These will be used as the arguments to the JavaScript finalize()
            // method.
            
            let resultsDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: resultsForJavaScriptFinalize]
            
            let resultsProvider = NSItemProvider(item: resultsDictionary as NSDictionary, typeIdentifier: String(kUTTypePropertyList))
            
            let resultsItem = NSExtensionItem()
            resultsItem.attachments = [resultsProvider]
            
            // Signal that we're complete, returning our results.
            self.extensionContext!.completeRequest(returningItems: [resultsItem], completionHandler: nil)
        } else {
            // We still need to signal that we're done even if we have nothing to
            // pass back.
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
        
        // Don't hold on to this after we finished with it.
        self.extensionContext = nil
    }
}

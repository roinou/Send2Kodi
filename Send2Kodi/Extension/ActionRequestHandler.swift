//
//  ActionRequestHandler.swift
//  SendYouTube2Kodi
//
//  Created by Erwan Lacoste on 18/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

import UIKit
import MobileCoreServices

/// base ActionRequestHandler that will send a Youtube ID to a target system
protocol ActionRequestHandler: NSObject, NSExtensionRequestHandling {
    
    var extensionContext: NSExtensionContext? { get set }
    
    /// init the ShareService to use
    /// - Parameter config: the ConfigService to use
    func initService(config: ConfigService) -> ShareService
    
    /// delegator for NSExtensionRequestHandling.beginRequest
    func doBeginRequest(with context: NSExtensionContext)
}

extension ActionRequestHandler {
    
    private func prepareService() -> ShareService {
        let userDefaults = UserDefaults(suiteName: "group.be.vershina.Send2Kodi2") ?? .standard
        let config = ConfigService(userDefaults)
        return self.initService(config: config)
    }

    func doBeginRequest(with context: NSExtensionContext) {
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

                                self.prepareService().send(item! as! String)
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
            self.doneWithResults(nil)
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(_ javaScriptPreprocessingResults: [String: Any]) {
        // Here, do something, potentially asynchronously, with the preprocessing
        // results.
        if let url = javaScriptPreprocessingResults["currentUrl"] as! String? {
            print("processing send 2 LMS with url: \(url)")
            
            self.prepareService().send(url)
        }
        self.doneWithResults(nil)
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

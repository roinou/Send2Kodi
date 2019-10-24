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
        
        var found = false
        
        let def = UserDefaults(suiteName: "group.be.vershina.Send2Kodi") ?? .standard
        let host = def.string(forKey: "host") ?? ""
        let port = def.string(forKey: "port") ?? ""
        
        print("begin request to send to \(host):\(port)")
        
        // Find the item containing the results from the JavaScript preprocessing.
        outer:
            for item in context.inputItems as! [NSExtensionItem] {
                if let attachments = item.attachments {
                    for itemProvider in attachments {
                        if itemProvider.hasItemConformingToTypeIdentifier("public.plain-text") {
                        
                            print("plain text")
                            
                            itemProvider.loadItem(forTypeIdentifier: "public.plain-text", options: nil, completionHandler: { (item, error) in
                                
                                let youtubeUrl = item as! String
                                print("url: \(youtubeUrl)")
                                let youtubeId = self.extractYoutubeId(youtubeUrl)
                                print("sending \(youtubeId) to \(host):\(port)")
                            })
                        }
                        
                        
                        if itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList)) {
                            itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil, completionHandler: { (item, error) in
                                let dictionary = item as! [String: Any]
                                OperationQueue.main.addOperation {
                                    self.itemLoadCompletedWithPreprocessingResults(dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as! [String: Any]? ?? [:])
                                }
                            })
                            found = true
                            break outer
                        }
                    }
                }
        }
        
        if !found {
            self.doneWithResults(nil)
        }
    }
    
    func itemLoadCompletedWithPreprocessingResults(_ javaScriptPreprocessingResults: [String: Any]) {
        // Here, do something, potentially asynchronously, with the preprocessing
        // results.
        
        // In this very simple example, the JavaScript will have passed us the
        // current background color style, if there is one. We will construct a
        // dictionary to send back with a desired new background color style.
        
        print("##### kodi ext load \(javaScriptPreprocessingResults)")
        
        
        let bgColor: Any? = javaScriptPreprocessingResults["currentBackgroundColor"]
        if bgColor == nil ||  bgColor! as! String == "" {
            // No specific background color? Request setting the background to red.
            self.doneWithResults(["newBackgroundColor": "red"])
        } else {
            // Specific background color is set? Request replacing it with green.
            self.doneWithResults(["newBackgroundColor": "green"])
        }
    }
    
    func doneWithResults(_ resultsForJavaScriptFinalizeArg: [String: Any]?) {
        if let resultsForJavaScriptFinalize = resultsForJavaScriptFinalizeArg {
            // Construct an NSExtensionItem of the appropriate type to return our
            // results dictionary in.
            
            // These will be used as the arguments to the JavaScript finalize()
            // method.
            

            print("##### kodi ext load")
            
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
    
    func extractYoutubeId(_ url: String) -> String {
        // either https://youtu.be/z29x-ZjtXfY or https://www.youtube.com/watch?v=z29x-ZjtXfY&feature=share
        let regex = try! NSRegularExpression(pattern: ".*/(watch\\?v=)?([^&/]*)(\\&.*)?")
        let matches = regex.matches(in: url, options: [], range: NSRange(location: 0, length: url.utf16.count))
        if let match = matches.first {
            if let swiftRange = Range(match.range(at:2), in: url) {
                return String(url[swiftRange])
            }
        }
        return ""
    }

}
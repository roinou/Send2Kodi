//
//  Action.js
//  SendYouTube2Kodi
//
//  Created by Erwan Lacoste on 18/10/2019.
//  Copyright © 2019 Erwan Lacoste. All rights reserved.
//

var Action = function() {};

Action.prototype = {
    
    run: function(arguments) {
        // Here, you can run code that modifies the document and/or prepares
        // things to pass to your action's native code.
        
        // just pass the URL to the native code
        arguments.completionFunction({ "currentUrl" : window.location.href })
    },
    
    finalize: function(arguments) {
        // This method is run after the native code completes.
        // it passes a boolean to stop the video
        if (arguments) {
            // long shot, let's try to stop the video:
            document.getElementById('movie_player').stopVideo()
        }
    }
    
};
    
var ExtensionPreprocessingJS = new Action

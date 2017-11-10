//
//  CollabHandler.swift
//  Collab
//
//  Created by Niko Arellano on 2017-11-08.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import Foundation


class CollabHandler {
    
    private static let _instance = CollabHandler()
    
    var usernameLoggedIn = ""
    var token : Token    = Token()
    
    static var Instance : CollabHandler {
        return _instance;
    }
    
}

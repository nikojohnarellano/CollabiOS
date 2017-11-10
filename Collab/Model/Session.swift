//
//  Room.swift
//  Collab
//
//  Created by Niko Arellano on 2017-10-21.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import Foundation

struct Session : Codable {
    
    var sessionId : Int?
    var sessionName : String?
    var sessionDescription : String?
    var usernameCreator : String?
    var password : String?
    var isPublic : Bool?
    var notes : [Note]?
    var creator  : User?
   
}

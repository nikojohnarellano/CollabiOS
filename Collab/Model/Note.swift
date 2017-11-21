//
//  Question.swift
//  Collab
//
//  Created by Niko Arellano on 2017-10-22.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import Foundation

struct Note : Codable {
    
    var noteId : Int?
    var question : String?
    var answer : String?
    var usernameOwner : String?
    var sessionId : Int?
    var session : Session?
    var owner : User?
    
}

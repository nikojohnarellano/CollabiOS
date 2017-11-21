//
//  NoteProvider.swift
//  Collab
//
//  Created by Niko Arellano on 2017-11-12.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import Foundation
import Alamofire

typealias FetchNotesForSessionHandler = (_ success : Bool, _ notes : [Note]?) -> Void
typealias PostNoteHandler             = (_ success : Bool, _ note  :  Note? ) -> Void

class NoteProvider {
    
    private static let _instance = NoteProvider()
    
    static var Instance : NoteProvider {
        return _instance;
    }
    
    public func fetchNotesForSession(session : Session, handler : FetchNotesForSessionHandler?) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CollabHandler.Instance.token.access_token!)",
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(Endpoints.local)api/session/\(session.sessionId!)/notes", headers: headers).responseString {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    do {
                        let notes = try? JSONDecoder().decode([Note].self, from : data.data(using : .utf8)!)
                        
                        if(notes?.count != 0) {
                            handler?(true, notes!)
                        } else {
                            handler?(false, nil)
                        }
                    }
                }
                
            case .failure(_):
                print("Error message:\(String(describing: response.result.error))")
                handler?(false, nil)
                break
            }
            
        }
    }
    
    public func postNote(note : Note, handler : PostNoteHandler?) {
        
        let params : Parameters = [
            "question"      : note.question!,
            "answer"        : note.answer!,
            "sessionId"     : note.sessionId!,
            "usernameOwner" : note.usernameOwner!
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CollabHandler.Instance.token.access_token!)",
            "Content-Type": "application/json"
        ]
        
        Alamofire.request("\(Endpoints.local)api/note",
            method     : .post,
            parameters : params,
            encoding   : JSONEncoding.default,
            headers : headers).responseString {
                response in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        do {
                            let note = try? JSONDecoder().decode(Note.self, from : data.data(using : .utf8)!)
                            
                            if(note != nil) {
                                // Request was a success
                                handler?(true, note!)
                            } else {
                                // Request was a success but no note was returned
                                handler?(true, nil)
                            }
                        }
                    }
                    
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    handler?(false, nil)
                    break
                }
                
        }
    }
    
}

//
//  DataProvider.swift
//  Collab
//
//  Created by Niko Arellano on 2017-11-01.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import Foundation
import Alamofire


typealias FetchAllSessionsHandler = (_ success : Bool, _ sessions : [Session]?) -> Void
typealias PostSessionHandler      = (_ success : Bool, _ session : Session?) -> Void

class SessionProvider{
    
    private static let _instance = SessionProvider()
    
    static var Instance : SessionProvider {
        return _instance;
    }
    
    public func fetchAllSessions(handler : FetchAllSessionsHandler?) {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CollabHandler.Instance.token.access_token!)",
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(Endpoints.local)api/session", headers: headers).responseString {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    do {
                        let sessions = try? JSONDecoder().decode([Session].self, from : data.data(using : .utf8)!)
                        
                        if(sessions?.count != 0) {
                            handler?(true, sessions)
                        } else {
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
    
    public func fetchSessionByName() {
        
    }
    
    public func fetchSessionById() {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJuaWtvb290aW5lMTIzQGdtYWlsLmNvbSIsImVtYWlsIjoibmlrb29vdGluZTEyM0BnbWFpbC5jb20iLCJpc3MiOiJkb3RuZXRfY29sbGFiLXNlc3Npb24iLCJhdWQiOiJDb2xsYWJTZXNzaW9uQXBpIiwibmJmIjoxNTA5NDM1NDI4LjAsImlhdCI6MTUwOTQzNTQyOC4wLCJleHAiOjE1MTAwNDM4MjguMH0.nKDc7wl1jHVsVy_VaQ6G9o409ZObdmNeU7EC_DNs0dw",
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(Endpoints.local)api/session/2", headers: headers).responseString {
            response in
            
            switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        do {
                            let sessionResult = try JSONDecoder().decode(Session.self, from : data.data(using : .utf8)!)
                            print(sessionResult)
                        } catch {
                            print(error)
                        }
                    }
                
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    break
            }
            
        }
    }
    
    public func postSession(session : Session, handler : PostSessionHandler?) {
     
        let params : Parameters = [
            "sessionName"        : session.sessionName!,
            "sessionDescription" : session.sessionDescription!,
            "password"           : session.password!,
            "usernameCreator"    : session.usernameCreator!,
            "isPublic"           : session.isPublic!,
        ]
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(CollabHandler.Instance.token.access_token!)",
            "Content-Type": "application/json"
        ]
        
        
        Alamofire.request("\(Endpoints.local)api/session",
            method     : .post,
            parameters : params,
            encoding   : JSONEncoding.default,
            headers : headers).responseString {
            response in
            
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    do {
                        let session = try? JSONDecoder().decode(Session.self, from : data.data(using : .utf8)!)
                        
                        if(session != nil) {
                            handler?(true, session!)
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

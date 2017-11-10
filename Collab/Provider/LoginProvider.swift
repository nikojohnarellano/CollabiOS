//
//  LoginProvider.swift
//  Collab
//
//  Created by Niko Arellano on 2017-11-05.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import Foundation
import Alamofire

typealias LoginHandler = (_ msg : String?, _ token : Token?) -> Void

class LoginProvider {
    private static let _instance = LoginProvider()
    
    static var Instance : LoginProvider {
        return _instance;
    }
    
    public func login(email : String, password : String, loginHandler : LoginHandler?) {
        let params : Parameters = [
            "email"    : email,
            "password" : password
        ]
        
        Alamofire.request("\(Endpoints.local)api/account/login",
                            method     : .post,
                            parameters : params,
                            encoding   : JSONEncoding.default).responseString {
            response in
            
            switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        do {
                            let token = try JSONDecoder().decode(Token.self, from : data.data(using : .utf8)!)
                            
                            if token.access_token != nil || token.id_token != nil {
                                loginHandler!(nil, token)
                            }
                        } catch {
                            loginHandler?("Authentication Failed. Please try again.", nil)
                        }
                    }
                case .failure(_):
                    print("Error message:\(String(describing: response.result.error))")
                    break
            }
            
        }
    }
}

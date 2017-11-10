//
//  SignInController.swift
//  Collab
//
//  Created by Niko Arellano on 2017-11-05.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

class SignInController: UIViewController {

    private let LOGIN_SEGUE = "LoginSegue"
    
    private var token : Token?
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(_ sender: Any) {
        LoginProvider.Instance.login(email : emailAddress.text!, password : password.text!, loginHandler: { (message, token) in
            if message != nil {
                self.alertTheUser(title  : "Problem with Authentication",
                                  message: message!)
            } else {
                
                CollabHandler.Instance.token            = token!
                CollabHandler.Instance.usernameLoggedIn = self.emailAddress.text!
                
                //self.token             = token
                self.emailAddress.text = ""
                self.password.text     = ""

                
                self.performSegue(withIdentifier: self.LOGIN_SEGUE, sender: nil)
                
            }
        })
    }
    
    private func alertTheUser(title : String, message : String) {
        let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
        
        let ok = UIAlertAction(title : "Ok", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated : true, completion: nil)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let navigationController = segue.destination as? CollabNavigationController {
            /*
            let sessionListController = navigationController.topViewController as? SessionListViewController
            sessionListController?.token = self.token
             */
            //CollabHandler.Instance.token = self.token!
            
        }
    }
    

}

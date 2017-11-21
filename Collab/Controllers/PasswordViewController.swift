//
//  PasswordViewController.swift
//  Collab
//
//  Created by Niko Arellano on 2017-10-22.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    var session : Session?
    
    @IBOutlet weak var password: UITextField!
    
    let PASSWORD_TO_SESSION = "PasswordToSessionSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func go(_ sender: Any) {
        
        if password.text! == self.session?.password {
            self.performSegue(withIdentifier: PASSWORD_TO_SESSION, sender: nil)
        } else {
            self.alertTheUser(title: "Wrong Password", message: "The password entered does not match the session's password")
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let sessionViewController = segue.destination as? NoteListController {
            sessionViewController.session = self.session!
        }
    }
    
    private func alertTheUser(title : String, message : String) {
        let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
        
        let ok = UIAlertAction(title : "Ok", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated : true, completion: nil)
    }
    

}

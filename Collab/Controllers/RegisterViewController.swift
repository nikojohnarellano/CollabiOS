//
//  RegisterViewController.swift
//  Collab
//
//  Created by Niko Arellano on 2017-11-15.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register(_ sender: Any) {
        
        if (password.text! == confirmPassword.text!) {
            let sv = UIViewController.displaySpinner(onView: self.view)
            
            if Connectivity.isConnectedToInternet() {
                AccountProvider.Instance.register(email: email.text!, password: password.text!, firstName: firstName.text!, lastName: lastName.text!) { (msg) in
                    
                    UIViewController.removeSpinner(spinner: sv)
                    
                    if msg != nil {
                        self.alertTheUser(title   : "Problem with Registration",
                                          message : msg!,
                                          dismiss : false)
                    } else {
                        self.alertTheUser(title   : "Registration Successful",
                                          message : "Success. You may now use Collab.",
                                          dismiss : true)
                    }
                }
            } else {
                self.alertTheUser(title: "No Network Found", message: "You need to have an internet connection to use Collab.", dismiss: false)
            }
            
        } else {
            self.alertTheUser(title   : "Validation Error",
                              message : "Passwords do not match.",
                              dismiss : false)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func alertTheUser(title : String, message : String, dismiss : Bool) {
        let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
        
        let ok = UIAlertAction(title : "Ok", style: .default) {
            (alert) in
            
            if (dismiss) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        alert.addAction(ok)
        
        present(alert, animated : true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CreateSessionViewController.swift
//  Collab
//
//  Created by Niko Arellano on 2017-10-21.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

protocol CreateSessionDelegate : class {
    func addSession(session : Session)
}

class CreateSessionViewController: UIViewController {
    
    @IBOutlet weak var sessionName: UITextField!
    
    @IBOutlet weak var sessionDescription: UITextView!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var isPublic: UISegmentedControl!
    
    weak var createSessionDelegate : CreateSessionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func createSession(_ sender: Any) {
        var session : Session = Session()
        
        session.sessionName        = sessionName.text!
        session.sessionDescription = sessionDescription.text!
        session.password           = password.text!
        session.isPublic           = isPublic.selectedSegmentIndex == 0
        session.usernameCreator    = CollabHandler.Instance.usernameLoggedIn
        session.notes              = [Note]()
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        if Connectivity.isConnectedToInternet() {
            SessionProvider.Instance.postSession(session: session) { (success, sessionResult) in
                
                UIViewController.removeSpinner(spinner: sv)
                
                if (success) {
                    self.alertTheUser(title: "Create Session", message: "Session was successfully created!", dismiss : true)
                    self.createSessionDelegate?.addSession(session: sessionResult!)
                } else {
                    self.alertTheUser(title: "Create Session", message: "Something wrong happened while creating the session.", dismiss : false)
                }
            }
        } else {
            self.alertTheUser(title: "No Network Found", message: "You need to have an internet connection to use Collab.", dismiss: false)
        }
        
  
    }
    
    private func alertTheUser(title : String, message : String, dismiss : Bool) {
        let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
        
        let ok = UIAlertAction(title : "Ok", style: .default) {
            (alert) in
            
            if (dismiss) {
                self.navigationController?.popViewController(animated: true)
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

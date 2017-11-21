//
//  JoinSessionViewController.swift
//  Collab
//
//  Created by Niko Arellano on 2017-11-20.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

class JoinSessionViewController: UIViewController {
    
    let JoinSessionToPasswordSegue = "JoinSessionToPasswordSegue"
    
    let JoinSessionToNoteListSegue = "JoinSessionToNoteListSegue"
    
    var sessions : [Session]?
    
    var selectedSession : Session?
    
    @IBOutlet weak var sessionName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func next(_ sender: Any) {
        
        for session in self.sessions! {
            if (session.sessionName == sessionName.text!) {
                self.selectedSession = session
                
                if (self.selectedSession?.password! != "") {
                    self.performSegue(withIdentifier: JoinSessionToPasswordSegue, sender: nil)
                } else {
                    self.performSegue(withIdentifier: JoinSessionToNoteListSegue, sender: nil)
                }
            }
        }
        
        if (selectedSession == nil) {
            self.alertTheUser(title: "Session Not Found", message: "The session name entered does not match any sessions available.")
        }
        
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
        if let viewControllerB = segue.destination as? PasswordViewController {
            viewControllerB.session = self.selectedSession!
        } else if let sessionView = segue.destination as? NoteListController {
            sessionView.session     = self.selectedSession!
        }
    }
    

}

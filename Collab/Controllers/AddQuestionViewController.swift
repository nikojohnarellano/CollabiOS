//
//  AddQuestionViewController.swift
//  Collab
//
//  Created by Niko Arellano on 2017-10-23.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

protocol AddQuestionDelegate : class {
    func addQuestion(question : Note)
}

class AddQuestionViewController: UIViewController {
    
    var session : Session?
    
    var addQuestionDelegate : AddQuestionDelegate?
    
    @IBOutlet weak var answer: UITextView!
    
    @IBOutlet weak var question: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func close(_ sender: Any) {
        
    }
    
    @IBAction func addNote(_ sender: Any) {
        var note : Note = Note()
        
        note.question       = question.text!
        note.answer         = answer.text!
        note.usernameOwner  = CollabHandler.Instance.usernameLoggedIn
        note.sessionId      = self.session?.sessionId
        note.session        = self.session
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        
        if Connectivity.isConnectedToInternet() {
            NoteProvider.Instance.postNote(note: note) { (success, noteResult) in
                
                UIViewController.removeSpinner(spinner: sv)
                
                if (success) {
                    self.alertTheUser(title: "Add Note", message: "Note was successfully added!", dismiss: true)
                    self.addQuestionDelegate?.addQuestion(question: note)
                } else {
                    self.alertTheUser(title: "Add Note", message: "Something wrong happened while adding a note.", dismiss : false)
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

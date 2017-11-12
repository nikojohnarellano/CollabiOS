//
//  RoomViewController.swift
//  Collab
//
//  Created by Niko Arellano on 2017-10-21.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

protocol SetQuestionsDelegate : class {
    func setQuestions(questions : [Note])
}

class SessionListViewController: UITableViewController, CreateSessionDelegate, AddQuestionDelegate {
    /*
    var sessions : [Session] = [
        Session(sessionId: 1,
                sessionName : "Data Comm Midterm",
                sessionDescription: "Please contribute a question when joining. Thanks!",
                usernameCreator : "nikoootine123@gmail.com",
                password : "",
                isPublic : true,
                notes : [
                    Note(question : "What is the definition of Deadlock", answer : "Deadlock is waiting for other process to finish"),
                    Note(question : "Mutual Exclusion Requirements", answer : "Its too many"),
                    Note(question : "Define Semaphore", answer : "semaphore uses int variable to identify flags")],
                creator : User(email : "nikoootine123@gmail.com",
                               firstName : "Niko",
                               lastName : "Arellano",
                               password: "")
                ),
        Session(sessionId : 2,
                sessionName : "Business Law Questions",
                sessionDescription: "Join this room to get access to midterm review questions",
                usernameCreator : "katehudson@gmail.com",
                password : "",
                isPublic : true,
                notes : [Note](),
                creator : User(email : "katehudson@gmail.com", firstName : "Kate", lastName : "Hudson", password : "")
               ),
        Session(sessionId : 3,
                sessionName : "Study Tips",
                sessionDescription: "A room made for students who are having trouble for midterms!",
                usernameCreator : "nikoootine123@gmail.com",
                password : "adasd",
                isPublic : true,
                notes : [
                    Note(question : "What is the definition of Deadlock", answer : "Deadlock is waiting for other process to finish"),
                    Note(question : "Mutual Exclusion Requirements", answer : "Its too many"),
                    Note(question : "Define Semaphore", answer : "semaphore uses int variable to identify flags")
                ],
                creator: User(email : "nikoootine123@gmail.com", firstName : "Niko", lastName : "Arellano", password: "")
                ),
    ]*/

    
    var sessions : [Session]?
    
    var selectedSession : Session?
    
    var token : Token?
    
    let ENTER_SESSION_SEGUE = "JoinSessionSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Load sessions
        
        SessionProvider.Instance.fetchAllSessions {
            (success, sessions) in
            
            if(success) {
                self.sessions = sessions!
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinSession(_ sender: Any) {
        //super.viewWillAppear(animated)
        
        
        let alertController = UIAlertController(title: "Join Room", message: nil, preferredStyle: .actionSheet)
        
        let scanQrButton = UIAlertAction(title: "Scan QR Code", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: self.ENTER_SESSION_SEGUE, sender: Any?.self)
        })
        
        let  enterSessionButton = UIAlertAction(title: "Enter Session Name", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: self.ENTER_SESSION_SEGUE, sender: Any?.self)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(scanQrButton)
        alertController.addAction(enterSessionButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)

    
    }


}

// Delegates
extension SessionListViewController {
    func addSession(session: Session) {
        self.sessions?.append(session)
        self.tableView.reloadData()
    }
    
    func addQuestion(session : Session, question: Note) {
        if var session = self.sessions?.first(where: {$0.sessionName == session.sessionName }) {
            session.notes?.append(question)
        }
    }
}


// Navigation extension
extension SessionListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewControllerB = segue.destination as? CreateSessionViewController {
            viewControllerB.createSessionDelegate = self
        } else if let sessionView = segue.destination as? SessionViewController {
            sessionView.session  = self.selectedSession!
        } else if let passwordView = segue.destination as? PasswordViewController {
            passwordView.session = self.selectedSession!
        }
    }
    
}

// Table View Data Source Extension
extension SessionListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let s = sessions {
            return s.count
        }
        return 0;
    }
    
    
    // Override row values initializer
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SessionTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! SessionTableViewCell
        
        let room = self.sessions![indexPath.row]
       
        /*
        cell.textLabel?.text = room.sessionName
        cell.detailTextLabel?.text = "Owned by: \(room.owner!.firstName!) \(room.owner!.lastName!)"
         */
        
        cell.sessionName.text = room.sessionName
        cell.sessionDescription.text = room.sessionDescription
        cell.sessionOwner.text = "Owned by: \(String(describing: (room.creator?.firstName!)!)) \(String(describing: (room.creator?.lastName!)!))"
 
        return cell 
    }
    
    
    // Override row selection from table view
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        let room = self.sessions![index]
     
        // TODO
        self.selectedSession = room
        
        // TODO
        if room.password != "" {
            self.performSegue(withIdentifier: "PasswordSegue", sender: Any?.self)
        } else {
            self.performSegue(withIdentifier: "PublicSessionSegue", sender: Any?.self)
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}

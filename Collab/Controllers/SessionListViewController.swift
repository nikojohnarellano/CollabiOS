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

class SessionListViewController: UITableViewController, CreateSessionDelegate {
    
    var sessions : [Session]?
    
    var selectedSession : Session?
    
    var token : Token?
    
    let ENTER_SESSION_SEGUE = "JoinSessionSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
        // Load sessions
        
        if Connectivity.isConnectedToInternet() {
            SessionProvider.Instance.fetchAllSessions {
                (success, sessions) in
                
                if(success) {
                    if let s = sessions {
                        self.sessions = s
                        self.tableView.reloadData()
                    }
                }
            }
        } else {
            self.alertTheUser(title: "No Network Found", message: "You need to have an internet connection to use Collab.")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logout(_ sender: Any) {
        CollabHandler.Instance.clearHandlers()
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinSession(_ sender: Any) {
        
        /*
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
        */
        self.performSegue(withIdentifier: self.ENTER_SESSION_SEGUE, sender: Any?.self)
    }

    private func alertTheUser(title : String, message : String) {
        let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
        
        let ok = UIAlertAction(title : "Ok", style: .default, handler: nil)
        
        alert.addAction(ok)
        
        present(alert, animated : true, completion: nil)
    }

}

// Delegates
extension SessionListViewController {
    func addSession(session: Session) {
        self.sessions?.append(session)
        self.tableView.reloadData()
    }
}


// Navigation extension
extension SessionListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewControllerB = segue.destination as? CreateSessionViewController {
            viewControllerB.createSessionDelegate = self
        } else if let sessionView = segue.destination as? NoteListController {
            sessionView.session  = self.selectedSession!
        } else if let passwordView = segue.destination as? PasswordViewController {
            passwordView.session = self.selectedSession!
        } else if let joinSessionView = segue.destination as? JoinSessionViewController{
            joinSessionView.sessions = self.sessions!
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

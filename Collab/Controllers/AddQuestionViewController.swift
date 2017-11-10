//
//  AddQuestionViewController.swift
//  Collab
//
//  Created by Niko Arellano on 2017-10-23.
//  Copyright © 2017 Mobilux. All rights reserved.
//

import UIKit

protocol AddQuestionDelegate : class {
    func addQuestion(session : Session, question : Note)
}

class AddQuestionViewController: UIViewController {
    
    var session : Session?
    var addQuestionDelegate : AddQuestionDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        
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

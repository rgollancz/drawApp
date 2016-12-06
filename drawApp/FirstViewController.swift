//
//  FirstViewController.swift
//  drawApp
//
//  Created by Rosie Gollancz on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties

    @IBOutlet weak var nameText: UITextField!
    let name: UITextField = UITextField()
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(nameText: UITextField) -> Bool{
        // Hide the Keyboard.
        nameText.resignFirstResponder()
        return true
    }
    
    private func textFieldDidEndEditing(nameText: UITextField) {
        name.text = nameText.text
        
    }

    
    //MARK: Actions
    
    @IBAction func playButton(_ sender: Any) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController1") as! SecondViewController1
         NSLog(myVC.stringPassed)
        myVC.stringPassed = myLabel.text!
         NSLog(myVC.stringPassed)
        navigationController?.pushViewController(myVC, animated: true)
        NSLog(myVC.stringPassed)
       
    }
}


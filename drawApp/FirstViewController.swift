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

    @IBOutlet weak var nameTextField: UITextField!
   
    var badText : String?
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        NSLog("hello0")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showSecondViewController" {
//            if let destination = segue.destination as? SecondViewController1 {
//                let dog = "woof"
//                destination.badText = dog
//                
//            }
//        }
//    }


    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         badText = textField.text
         NSLog(badText!)
    }
    
 
   
    //MARK: Actions
    
    @IBAction func playButton(_ sender: Any) {
        
    
//        performSegue(withIdentifier: "showSecondViewController", sender: sender )
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SecondViewController1") as! SecondViewController1
        
        myVC.stringPassed = badText
        
        navigationController?.pushViewController(myVC, animated: true)
       
       
  }
}


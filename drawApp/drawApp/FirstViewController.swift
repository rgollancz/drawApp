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
    var badText : String?
    
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDrawViewController" {
            if let destination = segue.destination as? DrawViewController {
                destination.badText = self.badText
                
            }
        }
    }
    
    
    //MARK: UITextFieldDelegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        badText = textField.text
    }
    
    
    //MARK: Actions
    
    @IBAction func playButton(_ sender: Any) {
        performSegue(withIdentifier: "showDrawViewController", sender: sender )
    }
}

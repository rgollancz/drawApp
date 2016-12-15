//
//  submitViewController.swift
//  
//
//  Created by Elizabeth Wicks on 15/12/2016.
//
//

import UIKit

class submitViewController: UIViewController {

   
   // @IBOutlet var sendLabel: UILabel!
   // var badText: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // sendLabel.text = ("\(badText), your drawing \n was sent!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "backDrawViewController" {
            if let destination = segue.destination as? DrawViewController {
               // destination.badText = self.badText
            }
        }
    }
    
    
    @IBAction func playAgainButton(_ sender: Any) {
        performSegue(withIdentifier: "backDrawViewController", sender: sender)
    }

}

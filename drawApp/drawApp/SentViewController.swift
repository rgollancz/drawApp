//
//  SentViewController.swift
//  drawApp
//
//  Created by Elizabeth Wicks on 15/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import UIKit

class SentViewController: UIViewController {
    
    var badText: String?

    @IBOutlet var sentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentLabel.text = "\(badText!), your drawing is \n off to be judged!"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "backDrawViewController" {
            if let destination = segue.destination as? DrawViewController {
                 destination.badText = self.badText
            }
        }
    }
    
    
    @IBAction func playAgainButton(_ sender: Any) {
        performSegue(withIdentifier: "backDrawViewController", sender: sender)
    }
    
}



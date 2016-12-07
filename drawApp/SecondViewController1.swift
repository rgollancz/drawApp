//
//  SecondViewController1.swift
//  drawApp
//
//  Created by Elizabeth Wicks on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import UIKit

class SecondViewController1: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    var badText: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = badText
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

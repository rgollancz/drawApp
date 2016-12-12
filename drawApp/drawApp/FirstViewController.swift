//
//  FirstViewController.swift
//  drawApp
//
//  Created by Rosie Gollancz on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import Starscream
import UIKit

final class FirstViewController: UIViewController, UITextFieldDelegate, WebSocketDelegate {
    
    let socket = WebSocket(url: URL(string: "ws://localhost:3000/")!)
    
    //MARK: Properties
    
    @IBOutlet weak var nameText: UITextField!
    var badText : String?
    
    
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket.delegate = self
        socket.connect()
        nameText.delegate = self
    }
    
    deinit {
        socket.disconnect(forceTimeout: 0)
        socket.delegate = nil
    }

    func websocketDidConnect(_ socket: WebSocket) {
    
    }
    
    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
        
    }

    func websocketDidReceiveMessage(_ socket: WebSocket, text: String) {
        
    }
    
    func websocketDidReceiveData(_ socket: WebSocket, data: Data) {
        
    }
    
//    func sendMessage(_ message: String) {
//        socket.write(string: message)
//    }
    
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

//
//// MARK: - FilePrivate
//fileprivate extension FirstViewController {
//    
//    func sendDrawing(_ message: String) {
//        socket.write(string: message)
//    }
//    
//    func drawingReceived(_ message: String) {
//        return
//    }
//}

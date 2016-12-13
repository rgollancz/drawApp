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
        // drawingReceived method
    }
    
    func websocketDidReceiveData(_ socket: WebSocket, data: Data) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDrawViewController" {
            if let destination = segue.destination as? DrawViewController {
                destination.badText = self.badText
//                destination.socket = self.socket
                
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
        sendDrawing(badText!);
        performSegue(withIdentifier: "showDrawViewController", sender: sender );
    }
    
    
    // Get drawing from drawViewController - on 'complete' button action
    
    
    // sendDrawing
    func sendDrawing(_ message: String) {
        print("bbbb")
        socket.write(string: message)
        print("aaa")
    }
    
    
    // drawingReceived
    

}








//
//  SecondViewController.swift
//  drawApp
//
//  Created by Rosie Gollancz on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import UIKit
import Starscream

class SecondViewController: UIViewController, UITextFieldDelegate, WebSocketDelegate {
    
    var answer = "cat"
    var guess: String?
    
    let socket = WebSocket(url: URL(string: "ws://localhost:3000/")!)

    @IBOutlet var guessPicture: UITextField!
    @IBOutlet weak var picturePage: UIImageView!
    @IBOutlet var responseCorrect: UIView!
    @IBOutlet var responseIncorrect: UIView!
    
    struct DrawingCoordinate {
        var from: CGPoint
        var to: CGPoint
        init(from: CGPoint, to: CGPoint) {
            self.from = from
            self.to = to
        }
    }
    
//    var coordinatesArray = [DrawingCoordinate]()


    override func viewDidLoad() {
        super.viewDidLoad()
        socket.delegate = self
        socket.connect()
        self.drawCoordinates()
        guessPicture.delegate = self
        responseCorrect.isHidden = true
        responseIncorrect.isHidden = true
    
    }
    
    
    var coordinatesArray:Array = [(from: (173.0, 180.5), to: (173.0, 180.0)),  (from: (173.0, 180.0), to: (173.5, 177.0)),  (from: (173.5, 177.0), to: (178.5, 169.5)),  (from: (178.5, 169.5), to: (182.5, 163.0)),  (from: (182.5, 163.0), to: (188.0, 156.0)),  (from: (188.0, 156.0), to: (192.0, 154.0)),  (from: (192.0, 154.0), to: (200.5, 153.0)),  (from: (200.5, 153.0), to: (212.0, 153.0)),  (from: (212.0, 153.0), to: (224.5, 153.5)),  (from: (224.5, 153.5), to: (232.5, 158.0))]
    
    func drawCoordinates() {
        
        for (x, y) in coordinatesArray {
        let from = x
        let to = y
        UIGraphicsBeginImageContextWithOptions(self.picturePage.bounds.size, false, 0.0)
            picturePage.image?.draw(in: CGRect(x: 0, y:0, width:self.picturePage.bounds.width, height:self.picturePage.bounds.height))

        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: from.0 , y: from.1))
        context?.addLine(to: CGPoint(x: to.0, y: to.1))
     
        context?.setBlendMode(CGBlendMode.color)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: 0.26, green: 0.53, blue: 0.96, alpha: 1.0).cgColor)
            
        context?.strokePath()
        
        picturePage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkAnswer() {
        if guessPicture.text == answer{
            responseCorrect.isHidden = false
        }
            
        else {
            
            responseIncorrect.isHidden = false
        }
        
    }
    
        //MARK: UITextFieldDelegate
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        responseIncorrect.isHidden = true
    }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            guess = guessPicture.text
            checkAnswer()
            guessPicture.text = ""
            return true
        }
        func textFieldDidEndEditing(_ textField: UITextField) {
            
        }
    
    
    @IBAction func drawPageButton(_ sender: Any) {
        performSegue(withIdentifier: "showTab", sender: sender )
    }

    @IBAction func tryAgain(_ sender: Any) {
          responseIncorrect.isHidden = true
    }
    @IBAction func giveUpButton(_ sender: Any) {
        performSegue(withIdentifier: "showTab", sender: sender )
    }

    func websocketDidConnect(_ socket: WebSocket) {
    
    }

    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
    
    }
    
    func drawingReceived() {
        
    }

    func websocketDidReceiveMessage(_ socket: WebSocket, text: String) {
        print("working")
        guard let data = text.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
                return
        }
        print(jsonDict)
        print(jsonData)
    
//        if messageType == "drawing",
//            let messageData = jsonDict["data"] as? [String: Any]
//            let messageAuthor = messageData["author"] as? String,
//            let messageText = messageData["text"] as? String 
//            {
//            drawingReceived()
//        }
        print(jsonDict)
        print(jsonData)
    }

    func websocketDidReceiveData(_ socket: WebSocket, data: Data) {
    
    }
    
}


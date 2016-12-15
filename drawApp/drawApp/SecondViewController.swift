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
    
    //MARK: Properties
    
    var answer: String?
    var guess: String?
    var receivedDrawing: String?
    let socket = WebSocket(url: URL(string: "ws://localhost:3000/")!)

    @IBOutlet var guessPicture: UITextField!
    @IBOutlet weak var picturePage: UIImageView!
    @IBOutlet var responseCorrect: UIView!
    @IBOutlet var responseIncorrect: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        socket.delegate = self
        socket.connect()
        guessPicture.delegate = self
        responseCorrect.isHidden = true
        responseIncorrect.isHidden = true
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func drawPageButton(_ sender: Any) {
        performSegue(withIdentifier: "showTab", sender: sender )
    }
    
    @IBAction func tryAgain(_ sender: Any) {
        responseIncorrect.isHidden = true
    }
    @IBAction func giveUpButton(_ sender: Any) {
        performSegue(withIdentifier: "showTab", sender: sender )
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
    
    
    func websocketDidConnect(_ socket: WebSocket) {
    }
    
    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
    }

    
    func nameReceived(_ name: String) {
        answer = name;
    }
    
    func drawingReceived(_ drawing: String) {
        receivedDrawing = drawing;
        
        let scanner = Scanner(string: receivedDrawing!)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "[], ")
        
        // Build the flat array
        var numbers = [Double]()
        while !scanner.isAtEnd {
            var d = 0.0
            if scanner.scanDouble(&d) {
                numbers.append(d)
            }
        }
        // Now the 2 dimensional array
        let result = stride(from: 0, to: numbers.count, by: 4).map { startIndex -> [Double] in
            let endIndex = min(startIndex + 4, numbers.count)
            return Array(numbers[startIndex..<endIndex])
        }
        drawCoordinates(result)
    }
    
    func drawCoordinates(_ array: [[Double]]) {
        for (elem) in array {
        let fromX = elem[0]
        let fromY = elem[1]
        let toX = elem[2]
        let toY = elem[3]
        UIGraphicsBeginImageContextWithOptions(self.picturePage.bounds.size, false, 0.0)
            picturePage.image?.draw(in: CGRect(x: 0, y:0, width:self.picturePage.bounds.width, height:self.picturePage.bounds.height))
    
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: fromX , y: fromY))
        context?.addLine(to: CGPoint(x: toX, y: toY))
    
        context?.setBlendMode(CGBlendMode.color)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: 0.26, green: 0.53, blue: 0.96, alpha: 1.0).cgColor)
    
        context?.strokePath()
    
        picturePage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
            
        }
    }

    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
        guard let data = text.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
                return
        }
        
        if messageType == "name" {
            let name = jsonDict["data"] as? String;
            nameReceived(name!)
        } else {
            let drawing = jsonDict["data"] as? String;
            drawingReceived(drawing!)
        }
    }

    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
    }
    
}


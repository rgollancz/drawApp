//
//  DrawViewController.swift
//  drawApp
//
//  Created by Rosie Gollancz on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import Foundation
import UIKit
import Starscream


class DrawViewController: UIViewController, WebSocketDelegate {
    
    @IBOutlet weak var drawPage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var clear: UIButton!
    @IBOutlet var currentWord: UILabel!
    
    @IBAction func showColorPicker(_ sender: Any) {
        let colorPickerViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "colorPickerId") as! ColorPickerViewController
        self.addChildViewController(colorPickerViewController)
        colorPickerViewController.view.frame = self.view.frame
        self.view.addSubview(colorPickerViewController.view)
        colorPickerViewController.didMove(toParentViewController: self)
    }
    
    let socket = WebSocket(url: URL(string: "ws://localhost:3000/")!)
    var badText: String?
    var lastPoint = CGPoint.zero
    var moved = false
    var jsonData : Data!
    
   
    let wordArray: [String] = ["CAT","TEAPOT","APPLE","BALLOON","NICKELBACK","GIRAFFE","HEADPHONES","MOUNTAIN","ROCK CLIMBING","FAMILY","CELEBRATE","KITE","WORLD MAP","HUMAN MIND","PUG","TIME","SISTINE CHAPEL","CAKE"]
    var word: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = badText
        self.setCurrentWord()
        self.currentWord.text = word
        socket.delegate = self
        socket.connect()
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moved = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.drawPage)
        }
    }
    
    func setCurrentWord() {
        let randomIndex = Int(arc4random_uniform(UInt32(wordArray.count)))
        word = wordArray[randomIndex]
    }
    
   
    
    struct DrawingCoordinate: {
        var from: CGPoint
        var to: CGPoint
        init(from: CGPoint, to: CGPoint) {
            self.from = from
            self.to = to
        }
    }
    
   
    
    var coordinatesArray = [[Float]]()
    
    
    func drawPicture(fromPoint:CGPoint, toPoint:CGPoint) {
        UIGraphicsBeginImageContextWithOptions(self.drawPage.bounds.size, false, 0.0)
        drawPage.image?.draw(in: CGRect(x: 0, y:0, width:self.drawPage.bounds.width, height:self.drawPage.bounds.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        coordinatesArray.append([Float(fromPoint.x), Float(fromPoint.y)])
        coordinatesArray.append([Float(toPoint.x), Float(toPoint.y)])
        
        context?.setBlendMode(CGBlendMode.color)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: 0.26, green: 0.53, blue: 0.96, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        drawPage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        moved = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.drawPage)
            drawPicture(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
            
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !moved {
            drawPicture(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    @IBAction func clear(_ sender: UIButton) {
        print(coordinatesArray);
        print(JSONSerialization.isValidJSONObject(coordinatesArray))
        drawPage.image = nil;
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backButton", sender: sender )
    }
    
    @IBAction func submitButton(_ sender: Any) {
        makingString()
    }
    
    func websocketDidConnect(_ socket: WebSocket) {
        
    }
    
    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
        
    }
    
    @IBOutlet weak var test: UILabel!
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
        print("hello")

//        guard let data = text.data(using: .utf16),
//        let jsonData = try? JSONSerialization.jsonObject(with: data),
//        let jsonDict = jsonData as? [String: Any],
//        let name = jsonDict["name"] as? String else {
//            return
//        }
//        test.text = name
    }
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
        print("hello")
        print(data)
    }

    
    func makingString () {
        do {
            
            //Convert to Data
            jsonData = try JSONSerialization.data(withJSONObject: coordinatesArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            
//            //Convert back to string. Usually only do this for debugging
//            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
//                print(JSONString)
//            }
//            
//            //In production, you usually want to try and cast as the root data structure. Here we are casting as a dictionary. If the root object is an array cast as [AnyObject].
//            json = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [AnyObject]
//            
        } catch {
            return
        }
        socket.write(data: jsonData)
    }

}

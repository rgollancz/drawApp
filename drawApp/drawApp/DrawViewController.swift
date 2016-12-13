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
    
   
    
    struct DrawingCoordinate: JSONSerializable {
        var from: CGPoint
        var to: CGPoint
        init(from: CGPoint, to: CGPoint) {
            self.from = from
            self.to = to
        }
    }
    
    let coordinatesArray = [(from: (173.0, 180.5), to: (173.0, 180.0)),  (from: (173.0, 180.0), to: (173.5, 177.0))]

    if let json = coordinatesArray.toJSON() {
        print(json)
    }
    
    var coordinatesArray = [DrawingCoordinate]()
    
    
    func drawPicture(fromPoint:CGPoint, toPoint:CGPoint) {
        UIGraphicsBeginImageContextWithOptions(self.drawPage.bounds.size, false, 0.0)
        drawPage.image?.draw(in: CGRect(x: 0, y:0, width:self.drawPage.bounds.width, height:self.drawPage.bounds.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        coordinatesArray.append(DrawingCoordinate(from: fromPoint, to: toPoint))
        
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
        print(type(of: coordinatesArray));
        drawPage.image = nil;
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backButton", sender: sender )
    }
    
    @IBAction func submitButton(_ sender: Any) {
        socket.write(string: "this is a test")
    }
    
    func websocketDidConnect(_ socket: WebSocket) {
        
    }
    
    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
        
    }
    
    @IBOutlet weak var test: UILabel!
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
//        let parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
//        guard let drawing = parsedData[0] as? [String: AnyObject],
//        var thing = drawing["name"] as [String: AnyObject] else {
//            return;
        guard let data = text.data(using: .utf16),
        let jsonData = try? JSONSerialization.jsonObject(with: data),
        let jsonDict = jsonData as? [String: Any],
        let name = jsonDict["name"] as? String else {
            return
        }
        test.text = name
    }
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
        
    }

}

    protocol JSONRepresentable {
        var JSONRepresentation: AnyObject {get}
    }

    protocol JSONSerializable: JSONRepresentable {
    
    }

    extension JSONSerializable {
        var JSONRepresentation: AnyObject {
            var representation = [String: AnyObject]()
        
            for case let (label?, value) in Mirror(reflecting: self).children {
                switch value {
                    
                case let value as JSONRepresentable:
                    representation[label] = value.JSONRepresentation
                    
                    
                case let value as Array<AnyObject>:
                    representation[label] = value as AnyObject?
                    
                    
//                case let value as Array<JSONSerializable>:
//                    representation[label] = value.map({$0.JSONRepresentation})
                
                case let value as NSObject:
                    representation[label] = value
                
                default:
                // Ignore any unserializable properties
                break
            }
        }
        
        return representation as AnyObject
    }
        
        func toJSON() -> String? {
            let representation = JSONRepresentation
            
            guard JSONSerialization.isValidJSONObject(representation) else {
                return nil
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: representation, options: [])
                return String(data: data, encoding: String.Encoding.utf8)
            } catch {
                return nil
            }
        }
    }



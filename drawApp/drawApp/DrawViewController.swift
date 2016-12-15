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
    //MARK: Properties
    
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
    
    let socket = WebSocket(url: URL(string: "IP ADD")!)
    var badText: String?
    var lastPoint = CGPoint.zero
    var moved = false
    var jsonData : Data!
    var timer = Timer()
    var counter = 5
    var drawingAllowed = true
    var timerFlash = Timer()
    var counterFlash = 3

   
    @IBOutlet var counterLabel: UILabel!
   
    @IBOutlet var clearButtonLabel: UIButton!
    @IBOutlet var submitButtonLabel: UIButton!
    
    let wordArray: [String] = ["CAT","TEAPOT","APPLE","BALLOON","NICKELBACK","GIRAFFE","HEADPHONES","MOUNTAIN","ROCK CLIMBING","FAMILY","CELEBRATE","KITE","WORLD MAP","HUMAN MIND","PUG","TIME","SISTINE CHAPEL","CAKE"]
    var word: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counter)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        self.nameLabel.text = badText
        self.setCurrentWord()
        self.currentWord.text = word
        socket.delegate = self
        socket.connect()
        submitButtonLabel.isHidden = true
    }
    
   //MARK: Actions
    
    func updateTimer() {
        if counter == 0 {
            timer.invalidate()
            counterLabel.text = String("Time's up!")
            changeViewOfButtons()
            flashTimer()
   
        } else{
            counter -= 1
            counterLabel.text = String(counter)
        }
    }
    
    func changeViewOfButtons() {
        clearButtonLabel.isHidden = true
        currentWord.isHidden = true
        submitButtonLabel.isHidden = false
        drawingAllowed = false
    }
    
    func flashTimer () {
        timerFlash = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(flashTimerAction), userInfo: nil, repeats: true)
    }
    
    func flashTimerAction() {
        counterLabel.isHidden = (counterLabel.isHidden == true) ? false : true
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
    
    struct DrawingCoordinate {
        var from: CGPoint
        var to: CGPoint
        init(from: CGPoint, to: CGPoint) {
            self.from = from
            self.to = to
        }
    }
    
   
    
    var coordinatesArray = [[Float]]()
    
    
    func drawPicture(fromPoint:CGPoint, toPoint:CGPoint) {
         if drawingAllowed == true {
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
         } else {
            return
        }
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
        drawPage.image = nil;
        coordinatesArray = []
    }
    
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "backButton", sender: sender )
    }
    
    @IBAction func submitButton(_ sender: Any) {
        sendString()
    }
    
    func websocketDidConnect(_ socket: WebSocket) {
        socket.write(string: currentWord.text!)
    }
    
    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
    }
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
        print("hello")


    }
    
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
    
    }
    
    func sendString() {
        let stringArray = coordinatesArray.flatMap { String(describing: $0) }
        let string = stringArray.joined(separator: ",")
        socket.write(string: string)
        
    }
}


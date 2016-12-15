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
    @IBOutlet var clearButtonLabel: UIButton!
    let socket = WebSocket(url: URL(string: "http://192.168.48.104:3000")!)
    var badText: String?
    var lastPoint = CGPoint.zero
    var moved = false
    var jsonData : Data!
    var timer = Timer()
    var counter = 20
    var drawingAllowed = true
    var timerFlash = Timer()
    var counterFlash = 20
    @IBOutlet var counterLabel: UILabel!
    @IBOutlet var submitButtonLabel: UIButton!
    var nibColour = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0).cgColor
    var coordinatesArray = [[Float]]()
    let wordArray: [String] = ["CAT","TEAPOT","APPLE","BALLOON","FIREWORKS","GIRAFFE","HEADPHONES","MOUNTAIN","ROCK CLIMBING","FAMILY","CELEBRATE","KITE","WORLD MAP","HUMAN MIND","PUG","TIME","SISTINE CHAPEL","CAKE", "CHRISTMAS TREE", "KERMIT"]
    var word: String?
    @IBOutlet var colourOptions: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String("00:\(counter)")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
           flashTimer()
        self.nameLabel.text = badText
        self.setCurrentWord()
        self.currentWord.text = word
        socket.delegate = self
        socket.connect()
        submitButtonLabel.isHidden = true
        colourOptions.isHidden = true
    }
    
   //MARK: Actions
    
    func updateTimer() {
        if counter == 0 {
            timer.invalidate()
            counterLabel.text = String("Time's up!")
            changeViewOfButtons()
            timerFlash.invalidate()
        } else{
            counter -= 1
            counterLabel.text = String("00:\(counter)")
        }
    }
    
    func changeViewOfButtons() {
        clearButtonLabel.isHidden = true
        currentWord.isHidden = true
        submitButtonLabel.isHidden = false
        drawingAllowed = false
    }
    
    func flashTimer () {
        timerFlash = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(flashTimerAction), userInfo: nil, repeats: true)
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
        context?.setStrokeColor(nibColour)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "showSentViewController" {
            if let destination = segue.destination as? SentViewController {
              destination.badText = self.badText!
            }
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        sendString()
        performSegue(withIdentifier: "showSentViewController", sender: sender)
    }
    
    func websocketDidConnect(_ socket: WebSocket) {
        socket.write(string: currentWord.text!)
    }
    
    func websocketDidDisconnect(_ socket: WebSocket, error: NSError?) {
    }
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
    }
    
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
    }
    
    func sendString() {
        let stringArray = coordinatesArray.flatMap { String(describing: $0) }
        let string = stringArray.joined(separator: ",")
        socket.write(string: string)
    }
    
    
    @IBAction func colourWheel(_ sender: Any) {
        colourOptions.isHidden = (colourOptions.isHidden == true) ? false: true
    }
    
    @IBAction func paintPink(_ sender: UIButton) {
        nibColour = UIColor(red: 1.0, green: 0.53, blue: 0.96, alpha: 1.0).cgColor
        colourOptions.isHidden = true
    }
    
    @IBAction func paintGreen(_ sender: UIButton) {
        nibColour = UIColor(red: 0.0, green: 1.0, blue: 0.20, alpha: 1.0).cgColor
        colourOptions.isHidden = true
    }
    
    @IBAction func paintBlue(_ sender: UIButton) {
       nibColour = UIColor(red: 0.26, green: 0.53, blue: 0.96, alpha: 1.0).cgColor
         colourOptions.isHidden = true
    }
    
    @IBAction func paintRed(_ sender: UIButton) {
          nibColour = UIColor(red: 1.0, green: 0.00, blue: 0.00, alpha: 1.0).cgColor
        colourOptions.isHidden = true
    }
    
    @IBAction func paintBlack(_ sender: Any) {
         nibColour = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0).cgColor
        colourOptions.isHidden = true
    }
  
    
    @IBAction func paintYellow(_ sender: UIButton) {
        nibColour = UIColor(red: 1.00, green: 1.00, blue: 0.00, alpha: 1.0).cgColor
        colourOptions.isHidden = true
    }
    
    }






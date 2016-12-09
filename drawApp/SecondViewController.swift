//
//  SecondViewController.swift
//  drawApp
//
//  Created by Rosie Gollancz on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var picturePage: UIImageView!
    
    var coordinatesArray = [DrawingCoordinate]()
    var fromCo = (from: 153.0, to: 180.0)
    var toCo = (from: 173.0, to: 180.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.drawCoordinate()
    }

    
    struct DrawingCoordinate {
        var from: CGPoint
        var to: CGPoint
        init(from: CGPoint, to: CGPoint) {
            self.from = from
            self.to = to
        }
    }
    
  
    
    func drawCoordinate() {
        UIGraphicsBeginImageContextWithOptions(self.picturePage.bounds.size, false, 0.0)
            picturePage.image?.draw(in: CGRect(x: 0, y:0, width:self.picturePage.bounds.width, height:self.picturePage.bounds.height))

        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: fromCo.from, y: fromCo.to))
        context?.addLine(to: CGPoint(x: toCo.from, y: toCo.to))
     
        context?.setBlendMode(CGBlendMode.color)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: 0.26, green: 0.53, blue: 0.96, alpha: 1.0).cgColor)
        
        context?.strokePath()
        picturePage.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    
//    func createPicture() {
//        for coordinate: DrawingCoordinate in coordinatesArray {
//        drawPicture(coordinate: DrawingCoordinate)
//    
//    
//        }
//    }
    
    
//    func drawPicture(coordinate:DrawingCoordinate) {
//        UIGraphicsBeginImageContextWithOptions(self.picturePage.bounds.size, false, 0.0)
//        picturePage.image?.draw(in: CGRect(x: 0, y:0, width:self.picturePage.bounds.width, height:self.picturePage.bounds.height))
//        let context = UIGraphicsGetCurrentContext()
//        
//        context?.move(to: CGPoint(x: DrawingCoordinate.from, y: DrawingCoordinate.from))
//        context?.addLine(to: CGPoint(x: DrawingCoordinate.to, y: DrawingCoordinate.to))
//        
//        context?.setBlendMode(CGBlendMode.color)
//        context?.setLineCap(CGLineCap.round)
//        context?.setLineWidth(5)
//        context?.setStrokeColor(UIColor(red: 0.26, green: 0.53, blue: 0.96, alpha: 1.0).cgColor)
//        
//        context?.strokePath()
//        
//        picturePage.image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//    }
//    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


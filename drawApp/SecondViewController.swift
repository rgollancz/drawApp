//
//  SecondViewController.swift
//  drawApp
//
//  Created by Rosie Gollancz on 06/12/2016.
//  Copyright © 2016 RAKE. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    
//    [drawApp.DrawViewController.DrawingCoordinate(from: (173.0, 180.5), to: (173.0, 180.0)), drawApp.DrawViewController.DrawingCoordinate(from: (173.0, 180.0), to: (173.5, 177.0)), drawApp.DrawViewController.DrawingCoordinate(from: (173.5, 177.0), to: (178.5, 169.5)), drawApp.DrawViewController.DrawingCoordinate(from: (178.5, 169.5), to: (182.5, 163.0)), drawApp.DrawViewController.DrawingCoordinate(from: (182.5, 163.0), to: (188.0, 156.0)), drawApp.DrawViewController.DrawingCoordinate(from: (188.0, 156.0), to: (192.0, 154.0)), drawApp.DrawViewController.DrawingCoordinate(from: (192.0, 154.0), to: (200.5, 153.0)), drawApp.DrawViewController.DrawingCoordinate(from: (200.5, 153.0), to: (212.0, 153.0)), drawApp.DrawViewController.DrawingCoordinate(from: (212.0, 153.0), to: (224.5, 153.5)), drawApp.DrawViewController.DrawingCoordinate(from: (224.5, 153.5), to: (232.5, 158.0))]

    @IBOutlet weak var picturePage: UIImageView!
    
   
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let coordinatesArray: [Any] = [(from: (173.0, 180.5), to: (173.0, 180.0)),(from: (173.0, 180.0), to: (173.5, 177.0)), (from: (173.5, 177.0), to: (178.5, 169.5)),(from:(178.5, 169.5), to: (182.5, 163.0)), (from:(182.5, 163.0), to: (188.0, 156.0)), (from: (188.0, 156.0), to: (192.0, 154.0))]
        
        self.publishImage(coordinatesArray: coordinatesArray)
    }

    
    struct DrawingCoordinate {
        var from: Double
        var to: Double
        init(from: (Double, Double), to: (Double, Double)) {
            self.from = from
            self.to = to
        }
    }
    
    
    func publishImage( coordinatesArray: [DrawingCoordinate]) {
        
        var coordinatesArray = coordinatesArray
       
        
        for i in 0..<coordinatesArray.count {
            var from = coordinatesArray[i].from
            var to = coordinatesArray[i].to
        drawCoordinate(from: from, to: to)
        }
    }
    
  
    
    func drawCoordinate(from: (Double, Double), to: (Double, Double)) {
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


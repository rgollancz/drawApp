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
        self.drawCoordinates()
    }
    
    
    var coordinatesArray:Array = [(from: (173.0, 180.5), to: (173.0, 180.0)),  (from: (173.0, 180.0), to: (173.5, 177.0)),  (from: (173.5, 177.0), to: (178.5, 169.5)),  (from: (178.5, 169.5), to: (182.5, 163.0)),  (from: (182.5, 163.0), to: (188.0, 156.0)),  (from: (188.0, 156.0), to: (192.0, 154.0)),  (from: (192.0, 154.0), to: (200.5, 153.0)),  (from: (200.5, 153.0), to: (212.0, 153.0)),  (from: (212.0, 153.0), to: (224.5, 153.5)),  (from: (224.5, 153.5), to: (232.5, 158.0)),  (from: (232.5, 158.0), to: (244.0, 167.5)),  (from: (244.0, 167.5), to: (254.0, 181.5)),  (from: (254.0, 181.5), to: (259.5, 195.0)),  (from: (259.5, 195.0), to: (263.5, 211.0)),  (from: (263.5, 211.0), to: (265.0, 226.0)),  (from: (265.0, 226.0), to: (265.0, 236.5)),  (from: (265.0, 236.5), to: (265.0, 256.5)),  (from: (265.0, 256.5), to: (263.0, 278.5)),  (from: (263.0, 278.5), to: (260.5, 291.0)),  (from: (260.5, 291.0), to: (256.5, 305.0)),  (from: (256.5, 305.0), to: (253.0, 312.5)),  (from: (253.0, 312.5), to: (248.5, 319.5)),  (from: (248.5, 319.5), to: (246.0, 322.0)),  (from: (246.0, 322.0), to: (243.0, 324.0)),  (from: (243.0, 324.0), to: (239.0, 327.0)),  (from: (239.0, 327.0), to: (234.5, 328.5)),  (from: (234.5, 328.5), to: (229.5, 329.5)),  (from: (229.5, 329.5), to: (225.5, 329.5)),  (from: (225.5, 329.5), to: (220.0, 327.5)),  (from: (220.0, 327.5), to: (215.0, 323.5)),  (from: (215.0, 323.5), to: (210.0, 321.0)),  (from: (210.0, 321.0), to: (206.0, 320.0)),  (from: (206.0, 320.0), to: (203.0, 319.5)),  (from: (203.0, 319.5), to: (201.0, 319.5)),  (from: (201.0, 319.5), to: (198.5, 320.0)),  (from: (198.5, 320.0), to: (197.0, 321.5)),  (from: (197.0, 321.5), to: (196.5, 322.5)),  (from: (196.5, 322.5), to: (195.5, 323.5)),  (from: (195.5, 323.5), to: (194.5, 325.0)),  (from: (194.5, 325.0), to: (193.5, 327.0)),  (from: (193.5, 327.0), to: (193.0, 328.0)),  (from: (193.0, 328.0), to: (192.5, 329.0)),  (from: (192.5, 329.0), to: (192.0, 330.0))]
    
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
    
    
//    func printCoo() {
//        for (x, y) in coordinatesArray {
////            print(x.0)
////            print(x.1)
//            print(y.0)
//            print(y.1)
//        }
//    }
//    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


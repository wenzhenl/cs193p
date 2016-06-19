//
//  ViewController.swift
//  MathGraph
//
//  Created by Wenzheng Li on 9/12/15.
//  Copyright (c) 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class MathGraphViewController: UIViewController, MathGraphDataSource
{
    @IBOutlet var mathGraphView: MathGraphView! {
        didSet {
            mathGraphView.dataSource = self
            mathGraphView.addGestureRecognizer(UIPinchGestureRecognizer(target: mathGraphView, action: "scale:"))
            let doubleTapGesture = UITapGestureRecognizer(target: mathGraphView, action: "changeOrigin:")
            doubleTapGesture.numberOfTapsRequired = 2
            mathGraphView.addGestureRecognizer(doubleTapGesture)
            mathGraphView.addGestureRecognizer(UIPanGestureRecognizer(target: mathGraphView, action: "move:"))
        }
    }

    var operation: (Double) -> Double? = { sin($0) }
        {
        didSet {
            updateUI()
        }
    }
    var expression: String = "Default title" {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        mathGraphView?.setNeedsDisplay()
        title = "\(expression)"
    }
    
    func pointsForMathGraphView(sender: MathGraphView, originX: CGFloat, scale: CGFloat, boundX: CGFloat) -> [CGPoint?]? {
        var points = [CGPoint?]()
        
        let minX = -Int(originX)
        let maxX = Int(boundX - originX)
        
        for var i = minX; i < maxX; ++i {
            let realX = Double(i) / Double(scale)
            if let result = operation(realX) {
                if result.isNormal || result.isZero {
                    points.append(CGPoint(x: realX, y: result))
                } else {
                    points.append(nil)
                }
            } else {
                points.append(nil)
            }
        }
        
        return points
    }
}


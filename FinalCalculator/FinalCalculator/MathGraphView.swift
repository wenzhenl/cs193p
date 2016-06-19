//
//  MathGraphView.swift
//  MathGraph
//
//  Created by Wenzheng Li on 9/12/15.
//  Copyright (c) 2015 Wenzheng Li. All rights reserved.
//

import UIKit

protocol MathGraphDataSource: class {
    func pointsForMathGraphView(sender: MathGraphView, originX: CGFloat, scale: CGFloat, boundX: CGFloat) -> [CGPoint?]?
}

@IBDesignable

class MathGraphView: UIView
{
    
    @IBInspectable
    var scale: CGFloat = 50 {didSet {setNeedsDisplay() }}
    
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() }}
    
    @IBInspectable
    var curveColor: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() }}
    
    var origin: CGPoint? = nil {didSet {setNeedsDisplay() }}
    
    weak var dataSource: MathGraphDataSource?
    
    func scale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    func changeOrigin(gesture: UITapGestureRecognizer) {
        switch gesture.state {
            case .Ended: fallthrough
            case .Changed: origin = gesture.locationInView(self)
        default: break
        }
    }
    
    private struct Constants {
        static let MathGraphGestureScale: CGFloat = 2
    }
    
    func move(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            case .Ended: fallthrough
            case .Changed:
                let translation = gesture.translationInView(self)
                let originChangeY = Int(translation.y / Constants.MathGraphGestureScale)
                let originChangeX = Int(translation.x / Constants.MathGraphGestureScale)
                if originChangeX != 0 || originChangeY != 0 {
                    origin = CGPoint(x: origin!.x + CGFloat(originChangeX), y: origin!.y + CGFloat(originChangeY))
                    gesture.setTranslation(CGPointZero, inView: self)
                }
            default: break
        }
    }
    
    func getPixelFromPointToDraw(point: CGPoint?) -> CGPoint?
    {
        if point == nil {
            return nil
        } else {
            return CGPoint(x: CGFloat(origin!.x + point!.x * scale), y: CGFloat(origin!.y - point!.y * scale))
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        if origin == nil {
            origin = CGPoint(x: bounds.width/2, y: bounds.height/2)
        }
        
        var axesDrawer = AxesDrawer(color: color, contentScaleFactor: contentScaleFactor)
        axesDrawer.drawAxesInRect(bounds, origin: origin!, pointsPerUnit: scale)
        
        var pointsToDraw = dataSource?.pointsForMathGraphView(self, originX: origin!.x, scale: scale, boundX: bounds.width) ?? [CGPoint(x: 0,y: 0)]
        //println("\(pointsToDraw)")
        
        pointsToDraw = pointsToDraw.map(getPixelFromPointToDraw)
        
        curveColor.set()
        var alreadyStartedDrawing = false
        let path = UIBezierPath()
        
        for var i = 0; i < pointsToDraw.count; ++i {
            if let point = pointsToDraw[i] {
                if alreadyStartedDrawing == false {
                    path.moveToPoint(point)
                    alreadyStartedDrawing = true
                } else {
                    path.addLineToPoint(point)
                }
            } else {
                alreadyStartedDrawing = false
            }
        }
        path.stroke()
    }
}

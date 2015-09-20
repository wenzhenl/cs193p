//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Wenzheng Li on 9/5/15.
//  Copyright (c) 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource
{
    static var something: String = "Haha"
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: "scale:"))
        }
    }
    
    private struct Constants {
        static let HappinessGestureScale: CGFloat = 4
    }
    
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(faceView)
            let happinessChange = -Int(translation.y / Constants.HappinessGestureScale)
            if happinessChange != 0 {
                happiness += happinessChange
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default: break
        }
    }
    
    var happiness: Int = 100 { // 0 = very sad, 100 = ecstatic
        didSet
        {
            happiness = min(max(happiness, 0),100)
            println("happiness = \(happiness)")
            updateUI()
        }
    }
    
    private func updateUI()
    {
        faceView?.setNeedsDisplay()
        title = "\(happiness)"
        
    }
    
    func smilinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness-50)/50
    }
}

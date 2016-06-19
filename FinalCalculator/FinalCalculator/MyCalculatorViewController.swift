//
//  ViewController.swift
//  MyCalculator
//
//  Created by Wenzheng Li on 9/5/15.
//  Copyright (c) 2015 Wenzheng Li. All rights reserved.
//

import UIKit

class MyCalculatorViewController: UIViewController {


    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    var alreadyHaveADecimalPoint = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
        display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func appendDecimalPoint(sender: UIButton) {
        if !alreadyHaveADecimalPoint {
          if userIsInTheMiddleOfTypingANumber {
              display.text = display.text! + "."
          } else {
              display.text = "0."
              userIsInTheMiddleOfTypingANumber = true
          }
           alreadyHaveADecimalPoint = true
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        
        if let operation = sender.currentTitle {
            displayValue = brain.performOperation(operation)
        }
        history.text = brain.getDescription() + "="
    }
    
    @IBOutlet weak var history: UILabel!
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        alreadyHaveADecimalPoint = false
        if displayValue != nil {
            displayValue = brain.pushOperand(displayValue!)
        }
        if brain.getDescription() != "" {
            history.text = brain.getDescription() + "="
        } else {
            history.text = " "
        }
    }
    
    var displayValue: Double? {
        get {
            if display.text != nil {
                return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
            } else {
                return nil
            }
        }
        
        set {
            if let updateValue = newValue {
                if updateValue == 0.0 {
                    display.text = "0"
                } else if updateValue.isNormal || updateValue.isZero {
                    display.text = "\(updateValue)"
                } else {
                    display.text = " "
                }
            } else {
                display.text = " "
            }
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func setM() {
        brain.setM(displayValue)
        userIsInTheMiddleOfTypingANumber = false
        alreadyHaveADecimalPoint = false
        displayValue = brain.evaluate()
    }
    
    
    @IBAction func undo() {
        if userIsInTheMiddleOfTypingANumber {
            displayValue = brain.evaluate()
            userIsInTheMiddleOfTypingANumber = false
            alreadyHaveADecimalPoint = false
        } else {
            displayValue = brain.undo()
            if brain.getDescription() != "" {
                history.text = brain.getDescription() + "="
            } else {
                history.text = " "
            }
        }
    }
    
    @IBAction func clear() {
        userIsInTheMiddleOfTypingANumber = false
        alreadyHaveADecimalPoint = false
        display.text = "0"
        history.text = " "
        brain.clear()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        
        if let mgvc = destination as? MathGraphViewController {
            if let identifier = segue.identifier {
                switch identifier {
                case "show graph": if let (operation, expression) = brain.getExpressionWithM() {
                        mgvc.operation = operation
                        mgvc.expression = expression
                }
                default: break
                }
            }
        }
    }
}


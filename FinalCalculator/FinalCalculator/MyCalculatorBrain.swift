//
//  MyCalculatorBrain.swift
//  MyCalculator
//
//  Created by Wenzheng Li on 9/5/15.
//  Copyright (c) 2015 Wenzheng Li. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private enum Op: Printable
    {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        case Constant(String, () -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperation(let symbol, _):
                    return symbol
                case .BinaryOperation(let symbol, _):
                    return symbol
                case .Constant(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String : Op]()
    
    private var variableValues = [String : Double]()
    
    private var valueOfM: Double? = nil
    
    var description: String {
        get {
            var expressions = [String]()
            var remainingOps = opStack
            do {
                let oprandDescription = describe(remainingOps)
                expressions.append(oprandDescription.description)
                remainingOps = oprandDescription.remainingOps
            } while !remainingOps.isEmpty
            
            var finalDescription = ""
            do {
                finalDescription += expressions.removeLast()
            if !expressions.isEmpty {
                finalDescription += ","
                }
            } while !expressions.isEmpty
            
            return finalDescription
        }
    }
    
    // return last valid expression
    private func describe(ops: [Op]) -> (description: String, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return ("\(operand)", remainingOps)
            case .UnaryOperation(let symbol, _):
                let oprandDescription = describe(remainingOps)
                return (symbol + "(" + describe(remainingOps).description + ")", oprandDescription.remainingOps)
            case .BinaryOperation(let symbol, _):
                let op1Description = describe(remainingOps)
                let description1 = op1Description.description
                let op2Description = describe(op1Description.remainingOps)
                let description2 = op2Description.description
                switch symbol {
                    case "+", "−":
                        return (description2  + symbol + description1, op2Description.remainingOps)
                default:
                    return ("(" + description2 + ")" + symbol + "(" + description1 + ")", op2Description.remainingOps)
                }
            case .Constant(let symbol, _):
                return (symbol, remainingOps)
            }
        }
        return ("", ops)
    }
    
    init() {
        func learnOps(op: Op) {
            knownOps[op.description] = op
        }
        learnOps(Op.BinaryOperation("×", *))
        learnOps(Op.BinaryOperation("÷") { $1 / $0 })
        learnOps(Op.BinaryOperation("+", +))
        learnOps(Op.BinaryOperation("−") { $1 - $0 })
        learnOps(Op.UnaryOperation("√", sqrt))
        learnOps(Op.UnaryOperation("sin", sin))
        learnOps(Op.UnaryOperation("cos", cos))
        learnOps(Op.Constant("π") { M_PI })
        learnOps(Op.Constant("M") { self.valueOfM ?? Double.NaN})
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Constant(_, let operation):
                return (operation(), remainingOps)
            }
        }
        return (nil, ops)
    }
    
    private func evaluate(ops: [Op], mValue: Double) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps, mValue: mValue)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps, mValue: mValue)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps, mValue: mValue)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            case .Constant(let symbol, let operation):
                if symbol == "M" {
                    return (mValue, remainingOps)
                }
                else {
                    return (operation(), remainingOps)
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func evaluate(mValue: Double) -> Double? {
        let (result, remainder) = evaluate(opStack, mValue: mValue)
        return result
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func pushOperand(symbol: String) -> Double? {
        if let operand = variableValues[symbol] {
            opStack.append(Op.Operand(operand))
            return evaluate()
        }
        return nil
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func getDescription() -> String {
        return description;
    }
    
    func setM(value: Double?) {
        valueOfM = value
    }
    
    func undo() -> Double? {
        if !opStack.isEmpty {
            opStack.removeLast()
            return evaluate()
        }
        return nil
    }
    
    func clear() {
        opStack = []
        valueOfM = nil
    }
    
    func getExpressionWithM() -> (operation: (Double) -> Double?, expression: String)? {
        let (expression, _) = describe(opStack)
        
        return ({
            self.evaluate($0)
        }, expression)
    }
}
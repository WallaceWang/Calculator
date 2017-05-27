//
//  ViewController.swift
//  Calculator
//
//  Created by 王晓睿 on 17/5/25.
//  Copyright © 2017年 王晓睿. All rights reserved.
//

import UIKit

//字符串扩展  操作符优先级
extension String{
    func priority() -> Int {
        if self == "#" {
            return 1
        }
        if self == "＋" || self == "－" {
            return 2
        }
        if self == "*" || self == "/" {
            return 3
        }
        return 0
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var displayInputLabel: UILabel!
    
    static var memoryValue: String = "" // 存储计算结果
    
    var expressionStack = Stack.init() //表达式栈
    var operatorStack = Stack.init() // 操作符栈
    
    var continueInput = true // 是否可以继续输入
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        operatorStack.push(string: "#") // 先在操作符栈入站最低优先级字符
        
    }
    
    // 输入的操作符，如果优先级低于操作符栈顶操作符的优先级，就把操作符栈顶元素出栈压入表达式栈，如果优先级高于操作符栈顶操作符优先级，就直接把输入的操作符压入表达式栈，这一步骤是为了是表达式转换为后缀表达式
    func unifyOpration(opration: String) {
        if displayInputLabel.text != "" {
            
            expressionStack.push(string: displayInputLabel.text!)
            
            while opration.priority() <= (operatorStack.peek?.priority())! {
                let operatorStackTop = operatorStack.pop()
                expressionStack.push(string: operatorStackTop!)
            }
            operatorStack.push(string: opration)
        }
        
    }
    
    // 处理小数点的方法，如果小数点后都是0，就截去，显示整型
    func dealDot(result: String) -> String {
        var index = 0
        
        for charactor in result.characters {
            index += 1
            if charactor == "." {
              let substr = (result as NSString).substring(from: index)
    
                if Int(substr)! == 0 {
                    let preStr = (result as NSString).substring(to: index - 1)
                    return preStr
                }
            }
        }
        let resultStr = Double(result) == 0 ? "0" : result
        return resultStr
    }
    
    // 等于
    @IBAction func equalBtn(_ sender: BaseButton) {
        
//        if displayInputLabel.text == "＋" || displayInputLabel.text == "－" || displayInputLabel.text == "*" || displayInputLabel.text == "/" {
//             operatorStack.pop()
//        }else{
//            expressionStack.push(string: displayInputLabel.text!)
//        }
        
        if displayInputLabel.text != "" {
            expressionStack.push(string: displayInputLabel.text!)
        }else{
            operatorStack.pop()// 如果输入框的值为空，说明最后一个输入的是操作符，所以就要出栈最后一个操作符
        }
        
        
        while operatorStack.size > 1 {
            expressionStack.push(string: operatorStack.pop()!) // 如果没有数字输入了，就把操作符栈的元素一次压栈到表达式栈
        }
        
        let reversedStack = Stack()
        while expressionStack.size > 0 {
            reversedStack.push(string: expressionStack.pop()!) // 把表达式栈逆序，方便计算
        }
        
        let valueStack = Stack() // 计算结果栈
        // 计算方法是，从表达式栈依次出栈元素，当是数字是就压入结果栈，当是操作符时，就从结果栈出栈两个元素计算后再压入结果栈，重复，知道计算出最后的结果
        while reversedStack.size > 0 {
            let vauleItem = reversedStack.pop()
            if vauleItem == "＋" {
                let lastItem = valueStack.pop()
                let firstItem = valueStack.pop()
                let resultItem = Double(firstItem!)! + Double(lastItem!)!
//                let resultItem = MutiplyBigNums.add(withBigNums: firstItem, num2: lastItem)
//                
                valueStack.push(string: String(resultItem))
                
            }else if vauleItem == "－"{
                let lastItem = valueStack.pop()
                let firstItem = valueStack.pop()
                let resultItem = Double(firstItem!)! - Double(lastItem!)!
                valueStack.push(string: String(resultItem))
            
            }else if vauleItem == "*"{
                let lastItem = valueStack.pop()
                let firstItem = valueStack.pop()
                
//                let firstDouble = Double(firstItem!)!
//                let lastDouble = Double(lastItem!)!
//                let resultItem = firstDouble * lastDouble
                
                // 大数相乘算法，为了保证大数相乘不溢出
                let resultItem = MutiplyBigNums.mutiply(withBigNums: firstItem, num2: lastItem)
                
//                let resultItem = Double(firstItem!)! * Double(lastItem!)!
                valueStack.push(string: resultItem!)
                
            }else if vauleItem == "/"{
                let lastItem = valueStack.pop()
                let firstItem = valueStack.pop()
                let resultItem = Double(firstItem!)! / Double(lastItem!)!
                valueStack.push(string: String(resultItem))
                
            }else{
                valueStack.push(string: vauleItem!)
            }
            
        }
        
        let resultValue = valueStack.pop()
        
        if resultValue == "inf" { // 分子为0
            displayInputLabel.text = "错误"
        }else if resultValue == "" || resultValue == nil{
        
        }else{
            displayInputLabel.text = dealDot(result: resultValue!) // 处理小数点后显示
        }
        
        continueInput = false // 显示结果时，不能进行编辑
        
    }
   // 乘法
    @IBAction func multiplyBtn(_ sender: BaseButton) {
       unifyOpration(opration: "*")
        displayInputLabel.text = ""
    }
   // 除法
    @IBAction func divisionBtn(_ sender: BaseButton) {
       unifyOpration(opration: "/")
        displayInputLabel.text = ""
    }
    // 加法
    @IBAction func addBtn(_ sender: BaseButton) {
       unifyOpration(opration: "＋")
        displayInputLabel.text = ""
    }
    // 减法
    @IBAction func subtractionBtn(_ sender: BaseButton) {
        unifyOpration(opration: "－")
        displayInputLabel.text = ""
    }
    
    // 退格
    @IBAction func deleteBtn(_ sender: BaseButton) {
        if continueInput && displayInputLabel.text != "" {
            
            displayInputLabel.text?.remove(at: (displayInputLabel.text?.index(before: (displayInputLabel.text?.endIndex)!))!)
        }
    }
    
    
    // m-
    @IBAction func mSubBtn(_ sender: BaseButton) {
        if ViewController.memoryValue != "" {
            ViewController.memoryValue = String(Double(ViewController.memoryValue)! - Double(displayInputLabel.text!)!)
        }
    }
    // m+
    @IBAction func mAddBtn(_ sender: BaseButton) {
        if ViewController.memoryValue == "" {
            ViewController.memoryValue = displayInputLabel.text!
        }else{
            ViewController.memoryValue = String(Double(ViewController.memoryValue)! + Double(displayInputLabel.text!)!)
        }
    }
    // mR
    @IBAction func mcBtn(_ sender: BaseButton) {
        if ViewController.memoryValue != "" {
            displayInputLabel.text = ViewController.memoryValue
        }
    }
    // Mc
    @IBAction func acBtn(_ sender: BaseButton) {
        displayInputLabel.text = ""
        ViewController.memoryValue = ""
    }
    
    // 数字键
    @IBAction func nineBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 { //如果先输入0则无效
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "9"
        
    }
    @IBAction func eightBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 {
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "8"
    }
    @IBAction func sevenBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 {
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "7"
    }
    @IBAction func sixBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 {
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "6"
    }
    @IBAction func fiveBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 {
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "5"
    }
    @IBAction func fourBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 {
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "4"
    }
    @IBAction func threeBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 {
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "3"
    }
    @IBAction func twoBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 {
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "2"
    }
    @IBAction func oneBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if Double(displayInputLabel.text!) == 0 {
            displayInputLabel.text = ""
        }
        displayInputLabel.text? += "1"
    }
    @IBAction func zeroBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        if (displayInputLabel.text? .hasPrefix("0"))! && !(displayInputLabel.text? .hasPrefix("0."))!   {
            
        }else{
            displayInputLabel.text? += "0"
        }
        
    }
   // 小数点
    @IBAction func dotBtn(_ sender: BaseButton) {
        if !continueInput{
            displayInputLabel.text = ""
            continueInput = true
        }
        
        if displayInputLabel.text == "" {
            displayInputLabel.text? += "0."
        }else if((displayInputLabel.text?.range(of: ".")) != nil){
        
        }else{
            displayInputLabel.text? += "."
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


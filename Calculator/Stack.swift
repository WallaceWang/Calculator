//
//  Stack.swift
//  Calculator
//
//  Created by 王晓睿 on 17/5/26.
//  Copyright © 2017年 王晓睿. All rights reserved.
//

import UIKit

// 栈 结构
public class Stack: NSObject {
    /// 是否为空
    public var isEmpty: Bool { return stack.isEmpty }
    /// 栈的大小
    public var size: Int { return stack.count }
    /// 栈顶元素
    public var peek: String? {
        return stack.last
    }
    
    private var stack: [String]
    
    /// 构造函数
    public override init() {
        stack = [String] ()
    }
    
    /// 加入一个新元素
    public func push(string: String) {
        stack.append(string)
    }
    
    /// 推出栈顶元素
    public func pop() -> String? {
        if isEmpty {
            return nil
        } else {
            return stack.removeLast()
        }
    }
}

//
//  MutiplyBigNums.m
//  Calculator
//
//  Created by 王晓睿 on 17/5/27.
//  Copyright © 2017年 王晓睿. All rights reserved.
//

#import "MutiplyBigNums.h"

// 大数相乘的算法，大数相乘依赖于大数相加算法
// 大数相加思想是把数值转换成字符串，然后每一位相加，结果直接插入在结果字符串的合适的位置
// 大数相乘的思想是，把数值转换成字符串，在把字符存到数组中，然后每一个相乘的结果与上一次计算的结果相加，如此循环知道计算出最终结果
@implementation MutiplyBigNums
+ (NSString *)mutiplyWithBigNums:(NSString *)num1 num2:(NSString *)num2
{
    
    NSString *result = [NSString string];
    
    //按两位来分组每一个乘数
    
    NSDictionary *num1Dict = [self tearStringToArray:num1];
    NSArray *arrayNum1 = [num1Dict objectForKey:@"numValue"]; // 数值字符串转换成的数组
    int dotNum1 = [self isHaveDot:num1Dict] ? [[num1Dict objectForKey:@"dotNum"] intValue] : 0; // 小数点的位数
    
    NSDictionary *num2Dict = [self tearStringToArray:num2];
    NSArray *arrayNum2 = [num2Dict objectForKey:@"numValue"];
    int dotNum2 = [self isHaveDot:num2Dict] ? [[num2Dict objectForKey:@"dotNum"] intValue]: 0;
    
    int dotNum = dotNum1 + dotNum2; // 两个数的小数点位数相加
    
    //循环分组内的元素，相乘
    
    NSString *tempResult = [NSString string];
    
    for (int i = 0 ; i < [arrayNum1 count] ; i ++){
        
        int item1 = [[arrayNum1 objectAtIndex:i] intValue];
        
        for (int j =0 ; j < [arrayNum2 count]; j ++){
            
            int item2 = [[arrayNum2 objectAtIndex:j] intValue];
            
            int temp = item1 * item2;
            
            tempResult = [NSString stringWithFormat:@"%d",temp];
            
            for (int k = 0 ; k < i + j ; k ++){
                
                tempResult = [tempResult stringByAppendingString:@"0"];
                
            }
            
            if (result.length){
                
                result = [self addWithBigNums:result num2:tempResult];
                
            }else{
                    
                result = tempResult;
            }
        }
    }
    
    // 根据两个数小数点位数，插入到结果字符串的合适的位置
    NSMutableString *resultString = [NSMutableString stringWithString:result];
    if (dotNum) {
        [resultString insertString:@"." atIndex:resultString.length - dotNum];
    }
    return [resultString copy];

}

// 将数值字符串转换成字典（包含字符串字符的数组和小数点位数）
+ (NSDictionary *)tearStringToArray:(NSString *)string

 {
     NSMutableDictionary *numResult = [NSMutableDictionary dictionaryWithCapacity:0];
     NSMutableArray *array = [NSMutableArray arrayWithCapacity:string.length];
     
    for (unsigned long i = string.length; i > 0; i --){
         
        NSString *temp = [string substringWithRange:NSMakeRange(i - 1, 1)];
        if ([temp isEqualToString:@"."]) {
            [numResult setObject:[NSNumber numberWithLong:string.length - i] forKey:@"dotNum" ];
        }else{
            [array addObject:temp];
        }
        
        [numResult setObject:array forKey:@"numValue"];
//        [array addObject:temp];
        
    }
    return [numResult copy];
//     return [array mutableCopy];
}

// 判断是否含有小数点
+ (BOOL)isHaveDot:(NSDictionary *)dict
{
   __block BOOL haveDot = NO;
    NSArray *array = [dict allKeys];
    [array enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"dotNum"]) {
            haveDot = YES;
        }
    }];
    return haveDot;
    
}

// 大数相加
+(NSString *)addWithBigNums:(NSString *)num1 num2:(NSString *)num2

{
    
    NSString *result = [NSString string];
    
    //确保num1大些，如果不是，则调换。
    
    if (num1.length < num2.length){
        
        result = [NSString stringWithString:num1];
        
        num1 = [NSString stringWithString:num2];
        
        num2 = [NSString stringWithString:result];
        
        result = [NSString string];
        
    }
    
    //进位
    int carryBit = 0;
    
    //加法的最大位
    int largestBit = 0;
    
    for (int i = 1 ; i <= num2.length ; i++){
        
        //num1 的当前位
        
        int intNum1 = [[num1 substringWithRange:NSMakeRange(num1.length - i, 1)] intValue];
        
        //num2 的当前位
        
        int intNum2 = [[num2 substringWithRange:NSMakeRange(num2.length - i, 1)] intValue];
        
        int intTemp = intNum1 + intNum2 + carryBit;
        
        if (intTemp > 9){
            
            carryBit = 1;
            
            result = [NSString stringWithFormat:@"%d%@",intTemp % 10,result];
            
        }else{
            
            carryBit = 0;
            
            result = [NSString stringWithFormat:@"%d%@",intTemp,result];
            
        }
        
        if (i == num2.length){
            
            if (num1.length == num2.length){
                
                if (carryBit) result = [NSString stringWithFormat:@"%d%@",carryBit,result];
                
            }else{
                
                for (int j = i ; j < num1.length; j++) {
                    int intNum3 = [[num1 substringWithRange:NSMakeRange(num1.length - j - 1, 1)] intValue];
                    
                    if (carryBit) {
                        
                        int intTemp3 = intNum3 + carryBit;
                        
                        if (intTemp3 > 9){
                            
                            carryBit = 1;
                            
                            result = [NSString stringWithFormat:@"%d%@",intTemp3 % 10,result];
                            
                        }else{
                            
                            carryBit = 0;
                            
                            result = [NSString stringWithFormat:@"%d%@",intTemp3,result];
                            
                        }

                    }else{
                        
                        result = [NSString stringWithFormat:@"%d%@",intNum3,result];
                    }
                    
                }
                
                if (carryBit) result = [NSString stringWithFormat:@"%d%@",carryBit,result];
                
            }
            
        }
        
    }
    
    return result;
    
}
@end

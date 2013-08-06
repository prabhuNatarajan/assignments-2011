//
//  RPNCalculatorBrain.m
//  RpnCalculator
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "RPNCalculatorBrain.h"
#import "RPNCalculatorViewController.h"

@interface RPNCalculatorBrain()
@property (nonatomic,strong) NSMutableArray *operandStack;//MutableArray for operandStack
@end

@implementation RPNCalculatorBrain
@synthesize operandStack=_operandStack;

- (NSMutableArray *) operandStack //method for operand stack
{
    if (!_operandStack) //checking the nil value of operand stack
    {
        _operandStack=[[NSMutableArray alloc]init];
    }
    return _operandStack;
}

- (void)pushOperand:(double)operand //method for pushing the operand into stack
{
    NSNumber *operandObject=[NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double)popOperand //method for poping out method from operand stack
{
    NSNumber *operandObject=[self.operandStack lastObject];
    if (operandObject)[self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation //method for performing operations on the operands
{
    double result=0;
    NSLog(@"%@",operation);
    
    if ([operation isEqualToString:@"+"]) //addition operation
        {
        result=[self popOperand]+[self popOperand];
        }
    else if ([operation isEqualToString:@"*"]) //multiplication operation
        {
        result=[self popOperand]*[self popOperand];
        }
    else if([@"-" isEqualToString:operation]) //subtraction operation
        {
        double subresult=[self popOperand];
        result=[self popOperand]-subresult;
        }
    else if([operation isEqual:@"sin"]) //sine operation
        {
        double sinv =[self popOperand];
        result=sin(sinv);
        }
    else if ([@"cos" isEqualToString:operation]) //cos operation
        {
        double coss = [self popOperand];
        result = cos(coss);
        }
    else if ([@"sqrt" isEqualToString:operation]) //square root operation
        {
        double sqrts = [self popOperand];
        result = sqrt(sqrts);
        }
    else if([@"/" isEqualToString:operation]) //division operation
        {
        double divresult=[self popOperand];
        if  (divresult) result=[self popOperand]/divresult;
        }
    else if ([@"π" isEqualToString:operation]) //Declaring PI Value
        {
        double pi=3.14159265358979;
        result = pi;
        }
    else if ([@"C" isEqualToString:operation]) //memory clearing
        {
        [self.operandStack removeAllObjects];
        }
    [self pushOperand:result];
    return result;
}

@end

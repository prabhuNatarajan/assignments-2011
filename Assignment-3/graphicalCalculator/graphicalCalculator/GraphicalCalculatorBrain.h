//
//  GraphicalCalculatorBrain.h
//  graphicalCalculator
//
//  Created by Apple on 03/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface GraphicalCalculatorBrain : NSObject

- (void)pushOperand:(double)operand;//method for pushsing the values into the array stack
- (double)performOperation:(NSString *)operation;//method for performing operation
- (void)pushVariable:(NSString *)variable;
- (void)emptyStack;
- (void)undoButton;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSMutableSet *)variablesUsedInProgram:(id)program;
+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
@property (nonatomic, readonly) id program;
@end

//
//  ProgramableCalculatorBrain.h
//  ProgramableCalculator
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgramableCalculatorBrain : NSObject

- (void)pushOperand:(double)operand; //for pushsing the values into the array stack
- (double)performOperation:(NSString *)operation; //method for performing operations on the operands
- (void)pushVariable:(NSString *)variable; //method for pushing variables(x,a,b) into stack
- (void)undoButton; //for undo button
- (void)clearProgramStack; //for emptying the program stack
+ (NSMutableSet *)variablesUsedInProgram:(id)program;
+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack; //for parenthesis operation
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
@property (nonatomic, readonly)id program; //for program stack mcopy

@end
//
//  ProgramableCalculatorViewController.m
//  ProgramableCalculator
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "ProgramableCalculatorViewController.h"
#import "ProgramableCalculatorBrain.h"
@interface ProgramableCalculatorViewController ()
@property (nonatomic) BOOL UserInTheMiddleOfEnteringNumber;//Property Declared for Removing 0 from Display
@property (nonatomic, strong) ProgramableCalculatorBrain *brain;
@property (nonatomic, strong) ProgramableCalculatorBrain *testBrain;
@property (nonatomic, strong) ProgramableCalculatorBrain *program;
@property (nonatomic, strong) NSDictionary *testVariablesValues;
@end

@implementation ProgramableCalculatorViewController

- (ProgramableCalculatorBrain *)brain
{
    if (!_brain)_brain = [[ProgramableCalculatorBrain alloc ]init];
    return _brain;
}

- (NSDictionary *)testVariablesValues
{
    if (!_testVariablesValues)_testVariablesValues = [[NSDictionary alloc]init];
    return _testVariablesValues;
}

- (IBAction)operandButtonsPressed:(UIButton *)sender//Method for operand buttons(0,1,2,3,4,5,6,7,8,9,.)
{
    NSLog(@"%@", [sender currentTitle]);
    NSString *operandPressed = [sender currentTitle];
    {
    //For Preventing the Illegal Floating point number
    if ([operandPressed isEqualToString:@"."])
      {
        self->numberOfDot ++;
      }
        if (self.UserInTheMiddleOfEnteringNumber)
        {
            if (self->numberOfDot <2)
                {
                self.resultDisplay.text = [self.resultDisplay.text stringByAppendingString:operandPressed];
                }
            else if (![operandPressed isEqualToString:@"."])
                self.resultDisplay.text = [self.resultDisplay.text stringByAppendingString:operandPressed];
        }
        else
            {
            self.resultDisplay.text = operandPressed;
            self.UserInTheMiddleOfEnteringNumber = YES;
            }
    }
}

- (IBAction)variableButtonsPressed:(UIButton *)sender//Method for Variables (X,A,B)
{
    if (self.UserInTheMiddleOfEnteringNumber)
    {
        [self enterButtonPressed];
    }
    [self.brain pushVariable:sender.currentTitle];
    self.resultDisplay.text = sender.currentTitle;
    NSLog(@"%@",sender.currentTitle);
}

- (IBAction)enterButtonPressed//method for pressing enter button
{
    NSLog(@"Enter pressed");
    [self.brain pushOperand:[self.resultDisplay.text doubleValue]];
    self.UserInTheMiddleOfEnteringNumber = NO;
    self.memoryDisplay.text = [ProgramableCalculatorBrain  descriptionOfProgram:self.brain.program];
    self->numberOfDot=0;//setting the numberofdot value to "0"
    
}

- (IBAction)operationPressed:(UIButton *)sender//method for operation button(+,-,*,/,Sin,Cos,Sqrt,Pi)
{
    NSLog(@"%@",[sender currentTitle]);
    if (self.UserInTheMiddleOfEnteringNumber)
    {
        [self enterButtonPressed];
    }
    if ([self.brain.program count]>0) //ignore user's pressing operation at the beginning
    {
        double result = [self.brain performOperation:sender.currentTitle];
        self.resultDisplay.text = [NSString stringWithFormat:@"%g",result];//Display the Result
        NSLog(@"%g",result);
        self.memoryDisplay.text = [ProgramableCalculatorBrain  descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)clearButton:(id)sender //method for clear button
{
    self.resultDisplay.text = @"0";
    self.variableValueDisplay.text = nil;
    self.memoryDisplay.text = nil;
    self.UserInTheMiddleOfEnteringNumber = NO;
    [self.brain clearProgramStack];
}

- (IBAction)testButtonsPressed:(UIButton *)sender //method for test buttons(Test 1, test 2, test 3)
{
   // NSLog(@"variablesUsedInProgram is: %@", [ProgramableCalculatorBrain variablesUsedInProgram:self.brain.program]);
    //set testVariablesValues to some preset testing values
    
    if ([sender.currentTitle isEqualToString:@"Test 1"])
    {
        self.testVariablesValues = @{ @"a": @3.0, @"b": @4.8, @"x": @5.0 };
    }
    
    if ([sender.currentTitle isEqualToString:@"Test 2"])
    {
        self.testVariablesValues = @{ @"a": @-3.0, @"b": @-4.8, @"x": @-5.0 };
    }
    
    if ([sender.currentTitle isEqualToString:@"Test C"])
    {
        self.testVariablesValues = nil;
    }

    //display discription of program
    self.memoryDisplay.text = [ProgramableCalculatorBrain descriptionOfProgram:self.brain.program];
    //display variable values
    self.variableValueDisplay.text = nil;
    NSSet *variablesUsedSet = [ProgramableCalculatorBrain variablesUsedInProgram:self.brain.program];
    NSArray *variablesUsedArray = [variablesUsedSet allObjects];
    if ([self.testVariablesValues count] > 0)
    {
        for (int i=0; i<[variablesUsedArray count]; i++)
        {
            if (!self.variableValueDisplay.text)
                {
                    self.variableValueDisplay.text = [NSString stringWithFormat:@"%@ = %@ ", [variablesUsedArray objectAtIndex:i], [self.testVariablesValues valueForKey:[variablesUsedArray objectAtIndex:i]]];
                }
                else
                {
                    self.variableValueDisplay.text = [NSString stringWithFormat:@"%@ = %@ ", [variablesUsedArray objectAtIndex:i], [self.testVariablesValues valueForKey:[variablesUsedArray objectAtIndex:i]]];
                }
        }
    }else
    {
        self.variableValueDisplay.text = nil;
    }
    //run program
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues:self.testVariablesValues];
    self.resultDisplay.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)undoButtonPressed //method for Undo Button
{
    if (self.UserInTheMiddleOfEnteringNumber && self.resultDisplay.text.length>1)
    {
        //remove the last digit from number
        self.resultDisplay.text = [self.resultDisplay.text substringToIndex:self.resultDisplay.text.length-1];
    }else
    {
        //clear top of stack and update display
        [self.brain undoButton];
        self.resultDisplay.text = @"0";
        self.memoryDisplay.text = [ProgramableCalculatorBrain  descriptionOfProgram:self.brain.program];
    }
}

@end
//
//  RPNCalculatorViewController.m
//  RpnCalculator
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "RPNCalculatorViewController.h"
#import "RPNCalculatorBrain.h"

@interface RPNCalculatorViewController ()
@property (nonatomic) BOOL userInMiddleOfEnteringNumber; //property declared for removing"0" from display
@property (nonatomic, strong) RPNCalculatorBrain *brain; //For storing operations
@end

@implementation RPNCalculatorViewController

- (RPNCalculatorBrain *)brain
{
    if(!_brain)_brain=[[RPNCalculatorBrain alloc]init];
    return _brain;
}

- (IBAction)operandButtonsPressed:(UIButton *)sender //Method for operand buttons(0,1,2,3,4,5,6,7,8,9,.)
{
    NSString *operandPressed = [sender currentTitle];
    NSLog(@"%@",operandPressed);
    {
        //For Preventing the Illegal Floating point number
        if ([operandPressed isEqualToString:@"."])
            {
            self->numberOfDot ++;
            }
            if (self.userInMiddleOfEnteringNumber)
            {
                if (self->numberOfDot <2)
                {
                    self.resultDisplay.text = [self.resultDisplay.text stringByAppendingString:operandPressed];
                }
            else if (![operandPressed isEqualToString:@"."])
                    self.resultDisplay.text = [self.resultDisplay.text stringByAppendingString:operandPressed];
            }
        else {
            self.resultDisplay.text = operandPressed;
            self.userInMiddleOfEnteringNumber = YES;
        }
    }
}

- (IBAction)enterButtonPressed //method for pressing enter button
{
    NSLog(@"Enter pressed");
    self.memoryDisplay.text = [self.memoryDisplay.text stringByAppendingString:self.resultDisplay.text];//memory display value
    self.memoryDisplay.text = [self.memoryDisplay.text stringByAppendingString:@" "];//memory display display space
    [self.brain pushOperand:[self.resultDisplay.text doubleValue]];
    self.userInMiddleOfEnteringNumber=NO;
    self->numberOfDot=0;//setting the numberofdot value to "0"
}

- (IBAction)clearButtonPressed:(id)sender //method for clear button
{
    self.resultDisplay.text = @"0";
    self.memoryDisplay.text = @"";
    self.userInMiddleOfEnteringNumber = NO;
}

- (IBAction)operationButtonsPressed:(id)sender //method for operation button(+,-,*,/,Sin,Cos,Sqrt,Pi,clear)
{
    // NSLog(@"%@",[sender currentTitle]);
    if (self.userInMiddleOfEnteringNumber)
    {
        [self enterButtonPressed];
    }
    NSString *operation=[sender currentTitle];
    double result=[self.brain performOperation:operation];
    self.resultDisplay.text=[NSString stringWithFormat:@"%g",result];//Display the Result
    NSLog(@"%g",result);
    self.memoryDisplay.text = [self.memoryDisplay.text stringByAppendingString:[sender currentTitle]];//memory display operation pressed
    self.memoryDisplay.text = [self.memoryDisplay.text stringByAppendingString:@" = "];//memory display "="
    self.memoryDisplay.text = [self.memoryDisplay.text stringByAppendingString:self.resultDisplay.text];//memory display Result
    self.memoryDisplay.text = [self.memoryDisplay.text stringByAppendingString:@" "];//memory display space
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

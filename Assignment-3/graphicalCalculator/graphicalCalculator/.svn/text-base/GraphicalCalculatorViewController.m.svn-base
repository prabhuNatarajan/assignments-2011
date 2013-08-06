//
//  GraphicalCalculatorViewController.m
//  graphicalCalculator
//
//  Created by Apple on 03/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "GraphicalCalculatorViewController.h"
#import "GraphicalCalculatorBrain.h"
#import "GraphicalCalculatorSplitViewBarButton.h"
#import "GraphicalCalculatorGraphViewController.h"

@interface GraphicalCalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;//Property Declared for Removing 0 from Display
@property (nonatomic,strong) GraphicalCalculatorBrain *brain;
@end
@implementation GraphicalCalculatorViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.splitViewController.delegate = self;
    //everytime awake from nip myself will control the split button
}

- (id<SplitViewBarButtonItemPresenter>) splitViewBarButtonItemPresenter
//ask the result must conform to the protocol, then it has the splitViewBarButtonItem to use in the next three methods
{
    id detailVC = [self.splitViewController.viewControllers lastObject];
    if (![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)])
    {
        detailVC = nil;
    }
    return detailVC;
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
    //only hide the detail View Controller when it's iPad and on portrait orientation
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    //put the button up
    barButtonItem.title = @"GraphicalCalculator";
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;    
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //take the button away
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;    
}

- (GraphicalCalculatorBrain *)brain
{
    if (!_brain)
        _brain = [[GraphicalCalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)undoButtonpressed //for undo button
{
    if (self.userIsInTheMiddleOfEnteringANumber && self.ResultDisplay.text.length>1)
    {
        //remove the last digit from number
        self.ResultDisplay.text = [self.ResultDisplay.text substringToIndex:self.ResultDisplay.text.length-1];
    }else
    {
        //clear top of stack and update display
        [self.brain undoButton];
        self.ResultDisplay.text = @"0";
        self.MemoryDisplay.text = [GraphicalCalculatorBrain  descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)operandButtonsPressed:(UIButton *)sender//Method for operand buttons(0,1,2,3,4,5,6,7,8,9,.)
{
    NSLog(@"%@",[sender currentTitle]);
    NSString *digit = [sender currentTitle];
    {
        //For Preventing the Illegal Floating point number
        if ([digit isEqualToString:@"."])
        {
            self->numberOfDot ++;
        }
        if (self.userIsInTheMiddleOfEnteringANumber)
        {
            if (self->numberOfDot <2)
            {
                self.ResultDisplay.text = [self.ResultDisplay.text stringByAppendingString:digit];
            }
            else
                if (![digit isEqualToString:@"."])
                    self.ResultDisplay.text = [self.ResultDisplay.text stringByAppendingString:digit];
        }
        else
        {
            self.ResultDisplay.text = digit;
            self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }    
}

- (IBAction)variableButtonPressed:(UIButton *)sender//Method for Variables (X,)
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterButtonPressed];
    }
    [self.brain pushVariable:sender.currentTitle];
    self.ResultDisplay.text = sender.currentTitle;
}

- (IBAction)enterButtonPressed//method for pressing enter button
{
    [self.brain pushOperand:[self.ResultDisplay.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.MemoryDisplay.text = [GraphicalCalculatorBrain descriptionOfProgram:self.brain.program];
    self->numberOfDot = 0;
}

- (IBAction)operationButtonsPressed:(UIButton *)sender//method for operation button(+,-,*,/,Sin,Cos,Sqrt,Pi)
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        [self enterButtonPressed];
    }
    if ([self.brain.program count]>0)
    {
        //ignore user's pressing operation at the beginning
        double result = [self.brain performOperation:sender.currentTitle];
        self.ResultDisplay.text = [NSString stringWithFormat:@"%g",result];
        self.MemoryDisplay.text = [GraphicalCalculatorBrain descriptionOfProgram:self.brain.program];
    }
}

- (IBAction)clearButtonPressed//method for clear button
{
    self.ResultDisplay.text = @"0";
    [self.brain emptyStack];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.MemoryDisplay.text = nil;
}

- (GraphicalCalculatorGraphViewController *)splitViewGraphViewController
{
    id gvc = [self.splitViewController.viewControllers lastObject];
    if (![gvc isKindOfClass:[GraphicalCalculatorGraphViewController class]]) gvc = nil;
    return gvc;
}// to get the gvc, because this method clearly define the result as a GraphViewController to be used in next method.

- (IBAction)graphButtonPressed
{
    if ([self splitViewGraphViewController])
    {//ipad
        [self splitViewGraphViewController].program = self.brain.program;
        [self splitViewGraphViewController].DisplaySagued = self.MemoryDisplay;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowGraph"])
    {
        [segue.destinationViewController setProgram:self.brain.program];
        [segue.destinationViewController setDisplaySagued:self.MemoryDisplay];        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //ipad support autoroation, iphone only support portrait (though its graph does support)
    return [self splitViewBarButtonItemPresenter] ? YES : toInterfaceOrientation == UIInterfaceOrientationPortrait;
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
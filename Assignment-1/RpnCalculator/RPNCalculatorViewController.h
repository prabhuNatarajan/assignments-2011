//
//  RPNCalculatorViewController.h
//  RpnCalculator
//
//  Created by Apple on 31/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPNCalculatorViewController : UIViewController
{
    NSInteger numberOfDot;
}
@property (weak, nonatomic) IBOutlet UILabel *resultDisplay;
@property (weak, nonatomic) IBOutlet UILabel *memoryDisplay;

@end

//
//  GraphicalCalculatorViewController.h
//  graphicalCalculator
//
//  Created by Apple on 03/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphicalCalculatorViewController : UIViewController<UISplitViewControllerDelegate>
{
    int numberOfDot;
}
@property (weak, nonatomic) IBOutlet UILabel *ResultDisplay;//Result Display
@property (weak, nonatomic) IBOutlet UILabel *MemoryDisplay;//Memory Display
@end

//
//  GraphicalCalculatorGraphViewController.h
//  graphicalCalculator
//
//  Created by Apple on 03/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphicalCalculatorSplitViewBarButton.h"

@interface GraphicalCalculatorGraphViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (nonatomic,strong) UIBarButtonItem *splitViewBarButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *GraphDisplay;//iphone Graph Description
@property (nonatomic, strong) id program;
@property (strong,nonatomic) UILabel *displaySagued;
@property (weak, nonatomic) IBOutlet UILabel *PadGraphDisplay;//ipad Graph result,description
@end
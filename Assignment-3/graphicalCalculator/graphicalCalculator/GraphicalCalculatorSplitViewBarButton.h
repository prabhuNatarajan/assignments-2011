//
//  GraphicalCalculatorSplitViewBarButton.h
//  graphicalCalculator
//
//  Created by Apple on 03/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SplitViewBarButtonItemPresenter <NSObject>
@property (nonatomic,strong) UIBarButtonItem *splitViewBarButtonItem;

@end
//
//  VirtualVacationFileAddViewController.h
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VirtualVacationFileAddDelegate;

@interface VirtualVacationFileAddViewController : UIViewController

@property (weak, nonatomic) id <VirtualVacationFileAddDelegate> delegate;

@end

@protocol VirtualVacationFileAddDelegate <NSObject>

- (BOOL)VirtualvacationFileAddViewController:(VirtualVacationFileAddViewController *)sender asksIfVacationWithGivenNameExists:(NSString *)name;
- (void)VirtualvacationFileAddViewController:(VirtualVacationFileAddViewController *)sender didAddVacation:(NSString *)vacationName;

@end
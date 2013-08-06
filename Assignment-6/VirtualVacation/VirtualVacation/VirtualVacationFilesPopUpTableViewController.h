//
//  VirtualVacationFilesPopUpTableViewController.h
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VirtualVacationFilesPopupDelegate;

@interface VirtualVacationFilesPopupTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *vacationNames;
@property (strong, nonatomic) id <VirtualVacationFilesPopupDelegate> delegate;

@end

@protocol VirtualVacationFilesPopupDelegate

- (void)VirtualVacationFilesPopupTableViewController:(VirtualVacationFilesPopupTableViewController *)sender didChooseVacation:(NSString *)vacation;

@end
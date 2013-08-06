//
//  VirtualCoreDataPhotoViewController.h
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"
#import "VirtualPhotoViewController.h"
#import "VirtualVacationFilesPopUpTableViewController.h"
#import "Photo.h"

@interface VirtualCoreDataPhotoViewController : VirtualPhotoViewController <VirtualVacationFilesPopupDelegate>

@property (strong, nonatomic) UIBarButtonItem *visitButton;
@property (strong, nonatomic) NSString *vacationName;
@property (strong, nonatomic) NSArray *vacations;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIDocument *document;
@property (strong, nonatomic) Photo *vacationPhoto;
@property (strong, nonatomic) VirtualVacationFilesPopupTableViewController *popoverData;
@property (assign, nonatomic) BOOL isOnVacation;

- (void)resetPhotoView;

@end
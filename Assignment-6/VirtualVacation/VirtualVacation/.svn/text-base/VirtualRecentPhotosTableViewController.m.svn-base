//
//  VirtualRecentPhotosTableViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualRecentPhotosTableViewController.h"
#import "VirtualPhotoListTableViewController.h"
#import "VirtualPhotosInPlaceViewController.h"
#import "VirtualCoreDataPhotoViewController.h"

@interface VirtualRecentPhotosTableViewController ()

@end

@implementation VirtualRecentPhotosTableViewController

- (NSArray *)getDefaultsPhotoData
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:DEFAULTS_RECENT_PHOTOS_KEY];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[self.splitViewController viewControllers] lastObject] isKindOfClass:[VirtualCoreDataPhotoViewController class]])
    {
        VirtualCoreDataPhotoViewController *coreDataPhotoViewController = [[self.splitViewController viewControllers] lastObject];
        [coreDataPhotoViewController resetPhotoView];
    }
    self.title = @"Recent photos";
    self.photos = [self getDefaultsPhotoData];
}

@end

//
//  VirtualVacationBrowsingTypeTableViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualVacationBrowsingTypeTableViewController.h"
#import "VirtualItineraryBrowserTableViewController.h"
#import "VirtualTagBrowserTableViewController.h"

@interface VirtualVacationBrowsingTypeTableViewController ()

@end

@implementation VirtualVacationBrowsingTypeTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = self.vacationName;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController respondsToSelector:@selector(setVacationName:)])
    {
        [segue.destinationViewController setVacationName:self.vacationName];
    }
}

@end


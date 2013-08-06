//
//  VirtualTagBrowserTableViewController.h
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface VirtualTagBrowserTableViewController : CoreDataTableViewController <UISearchBarDelegate>

@property (strong, nonatomic) NSString *vacationName;

@end
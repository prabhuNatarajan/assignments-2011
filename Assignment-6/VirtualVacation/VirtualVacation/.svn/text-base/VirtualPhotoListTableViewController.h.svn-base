//
//  VirtualPhotoListTableViewController.h
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_PHOTOS 50

@interface VirtualPhotosListTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *photos;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;

- (NSString *)getTitle:(NSDictionary *)photo;
- (NSString *)getSubtitle:(NSDictionary *)photo;
- (void)getThumbnailForCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexpath usingPhotoData:(NSDictionary *)photo;
@end

//
//  VirtualPhotoViewController.h
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULTS_RECENT_PHOTOS_KEY @"recentPhotosArray"

@interface VirtualPhotoViewController : UIViewController

@property (strong, nonatomic) NSDictionary *photo;
@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *downloadIndicator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;

- (void)resetPhotoView;
- (void)updateViewWithImage:(UIImage *)image;
- (void)storePhoto;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;

@end

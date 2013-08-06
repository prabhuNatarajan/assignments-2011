//
//  VirtualPhotoViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualPhotoViewController.h"
#import "FlickrFetcher.h"

#define MAX_RECENT_PHOTOS 25
#define IPAD_PORTRAIT_ORIENTATION_BAR_BUTTON_LABEL @"Table UI"

@interface VirtualPhotoViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation VirtualPhotoViewController

- (void)resetPhotoView
{
    self.imageView.image = nil;
    self.title = nil;
    self.titleBarButtonItem.title = nil;
}

- (void)storePhoto
{
    BOOL found=NO,needsUpdate=NO;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recentPhotos = [[defaults arrayForKey:DEFAULTS_RECENT_PHOTOS_KEY] mutableCopy];
    
    if (!recentPhotos)
    {
        recentPhotos = [NSMutableArray array];
    }
    for (NSDictionary *entry in recentPhotos)
    {
        if ([[entry objectForKey:FLICKR_PHOTO_ID] isEqualToString:[self.photo objectForKey:FLICKR_PHOTO_ID]])
        {
            found = YES;
            NSInteger entryFoundAtIndex = [recentPhotos indexOfObject:entry];
            if (entryFoundAtIndex)
            {
                [recentPhotos removeObjectAtIndex:entryFoundAtIndex];
                [recentPhotos insertObject:self.photo atIndex:0];
                needsUpdate = YES;
            }
            break;
        }
    }
    if (!found)
    {
        if ([recentPhotos count] >= MAX_RECENT_PHOTOS)
        {
            [recentPhotos removeLastObject];
        }
        [recentPhotos insertObject:self.photo atIndex:0];
        needsUpdate = YES;
    }
    if (needsUpdate)
    {
        [defaults setObject:[recentPhotos copy] forKey:DEFAULTS_RECENT_PHOTOS_KEY];
        [defaults synchronize];
    }
}

- (void)updateViewWithImage:(UIImage *)image
{
    _imageView = [[UIImageView alloc] initWithImage:image];
    [self.scrollView addSubview:_imageView];
    //setup scroll
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.delegate = self;
    //setup zooming.
    self.scrollView.minimumZoomScale = MIN(self.scrollView.bounds.size.width/self.imageView.image.size.width, self.scrollView.bounds.size.height/self.imageView.image.size.height);
    self.scrollView.maximumZoomScale = 2.0f;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    //setup image centring
    CGFloat offsetX = (_scrollView.bounds.size.width > _scrollView.contentSize.width)? (_scrollView.bounds.size.width - _scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (_scrollView.bounds.size.height > _scrollView.contentSize.height)? (_scrollView.bounds.size.height - _scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.scrollView.delegate = self;
    if (self.splitViewController)
    {
        self.splitViewController.delegate = self;
    }
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTap setNumberOfTapsRequired:2];
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale)
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    else
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewWillLayoutSubviews
{
    if (self.imageView.image)
    {
        float zoomScaleAfterOrientationChange = self.view.bounds.size.width / self.imageView.image.size.width;
        [self.scrollView setZoomScale:zoomScaleAfterOrientationChange];
    }
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = IPAD_PORTRAIT_ORIENTATION_BAR_BUTTON_LABEL;
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems insertObject:barButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    [toolbarItems removeObject:barButtonItem];
    self.toolbar.items = toolbarItems;
}

@end

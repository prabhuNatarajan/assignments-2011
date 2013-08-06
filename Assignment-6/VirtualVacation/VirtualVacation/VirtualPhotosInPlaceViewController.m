//
//  VirtualPhotosInPlaceViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualPhotosInPlaceViewController.h"
#import "FlickrFetcher.h"
#import "CoreDataTableViewController.h"
#import "VirtualCoreDataPhotoViewController.h"

@implementation VirtualPhotosInPlaceViewController

- (void)fetchPhotosInPlace:(NSDictionary *)place
{
    // initialize the queue used to download from flickr
    dispatch_queue_t fetchPhotoQ = dispatch_queue_create("Flickr photo fetcher", NULL);
    [self.activityIndicator startAnimating];
    dispatch_async(fetchPhotoQ,^{
        NSArray *fetchedPhotos = [FlickrFetcher photosInPlace:self.place maxResults:MAX_PHOTOS];
        self.photos = fetchedPhotos;
        // use the main queue to prepare for segue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.activityIndicator stopAnimating];
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.place)
    {
        [self fetchPhotosInPlace:self.place];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[[self.splitViewController viewControllers] lastObject] isKindOfClass:[VirtualCoreDataPhotoViewController class]])
    {
        VirtualCoreDataPhotoViewController *coreDataPhotoViewController = [[self.splitViewController viewControllers] lastObject];
        [coreDataPhotoViewController resetPhotoView];
    }
}

@end

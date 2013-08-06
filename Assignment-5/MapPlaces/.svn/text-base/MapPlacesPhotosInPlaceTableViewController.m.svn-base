//
//  MapPlacesPhotosInPlaceTableViewController.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesPhotosInPlaceTableViewController.h"
#import "FlickrFetcher.h"
#import "MapPlacesRecentPlacesTableViewController.h"
#import "MapPlacesRecentPlaces.h"
#import "MapPlacesPhotosInPlaceMapViewController.h"
#import "MapPlacesPhotosInPlaceAnnotation.h"
#import "MapPlacesPhotosViewController.h"

@interface MapPlacesPhotosInPlaceTableViewController ()<MapPlacesPhotosInPlaceMapViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *photoToDisplay;

@end

@implementation MapPlacesPhotosInPlaceTableViewController

-(void)setPhotos:(NSArray *)photos
{
    if (_photos != photos)
    {
        _photos = photos;
        [self.tableView reloadData];
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //spinner when downloading photo
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]init ];
    activityIndicator.frame = CGRectMake(self.view.frame.size.width/2 - activityIndicator.frame.size.width/2, self.view.frame.size.height/2 - activityIndicator.frame.size.height/2,activityIndicator.frame.size.width, activityIndicator.frame.size.height);
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    {
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *photos = [FlickrFetcher photosInPlace:self.place maxResults:20];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photos = photos;
                [activityIndicator stopAnimating];
            });
        });
    }
    NSString *title = [self.place objectForKey:FLICKR_PLACE_NAME];
    self.navigationItem.title = title;
    //for refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSString *photoTitle = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *photoDescription = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    if ([photoTitle length]==0 && [photoDescription length]!=0)
    {
        photoTitle = photoDescription;
        photoDescription = nil;
    }
    if ([photoTitle length]==0 && [photoDescription length]==0)
    {
        photoTitle = @"Unknown";
    }
    cell.textLabel.text = photoTitle;
    cell.detailTextLabel.text = photoDescription;  
    return cell;

}

- (void)segueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    self.photoToDisplay = sender;
    if (self.splitViewController)
    {
        [self MapPlacesPhotosViewController].photo = sender;//ipad
    }else
    {
        [self performSegueWithIdentifier:identifier sender:self];
    }
}

- (UIImage *)MapPlacesPhotosInPlaceMapViewController:(MapPlacesPhotosInPlaceMapViewController *)sender imageForAnnotation:(id<MKAnnotation>)annotation
{
    MapPlacesPhotosInPlaceAnnotation *fpa = (MapPlacesPhotosInPlaceAnnotation *)annotation;
    NSURL *url = [FlickrFetcher urlForPhoto:fpa.photo format:FlickrPhotoFormatSquare];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"downloading thumbnail from %@",url);
    return data ? [UIImage imageWithData:data] : nil;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Table Cell"])
    {
        if (self.view.window)
        {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            NSDictionary *photo = [self.photos objectAtIndex:path.row];
            [segue.destinationViewController setPhoto:photo];
            [MapPlacesRecentPlaces saveRecentUserDefaults:photo];
        }
        else
        {
            [segue.destinationViewController setPhoto:self.photoToDisplay];
        }
    }
    else if ([segue.identifier isEqualToString:@"Show Map"])
    {
        [segue.destinationViewController setPhotos:self.photos];
        [segue.destinationViewController setDelegate:self];
    }
}


- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    // custom refresh logic
    {
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *photos = [FlickrFetcher photosInPlace:self.place maxResults:20];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photos = photos;
            });
        });
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    NSLog(@"Photos %@", lastUpdated);
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (MapPlacesPhotosViewController *)MapPlacesPhotosViewController
{
    //For Split View
    UINavigationController *navigationController = [self.splitViewController.viewControllers lastObject];
    id phViewController = navigationController.topViewController;
    if (![phViewController isKindOfClass:[MapPlacesPhotosViewController class]])
    {
        phViewController = nil;
    }
    return phViewController;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self MapPlacesPhotosViewController])
    {//is on ipad
        NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
        [self MapPlacesPhotosViewController].photo = photo;
        [MapPlacesRecentPlaces saveRecentUserDefaults:photo];
    }
}

@end
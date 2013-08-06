//
//  MapPlacesRecentPlacesTableViewController.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesRecentPlacesTableViewController.h"
#import "MapPlacesRecentPlaces.h"
#import "FlickrFetcher.h"
#import "MapPlacesPhotosInPlaceTableViewController.h"
#import "MapPlacesPhotosViewController.h"

@interface MapPlacesRecentPlacesTableViewController()

@end

@implementation MapPlacesRecentPlacesTableViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    self.photos = [MapPlacesRecentPlaces retrieveRecentUserDefaults]; //if put in viewDidLoad, it only get called once after launching app
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    static NSString *CellIdentifier = @"Recent Photo Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    NSString *photoTitle = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *photoDescription = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    
    if ([photoTitle length] == 0 && [photoDescription length]!= 0)
    {
        photoTitle = photoDescription;
        photoDescription = nil;
    }
    if ([photoTitle length] == 0 && [photoDescription length] == 0)
    {
        photoTitle = @"Unknown";
    }
    cell.textLabel.text = photoTitle;
    cell.detailTextLabel.text = photoDescription;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *photo = [self.photos objectAtIndex:path.row];
    [segue.destinationViewController setPhoto:photo];
}

//For Split View
- (MapPlacesPhotosViewController *)splitViewMapPlacesViewController
{
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
    if ([self splitViewMapPlacesViewController])
    {
        //is on ipad
        NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
        [self splitViewMapPlacesViewController].photo = photo;
    }
}

@end
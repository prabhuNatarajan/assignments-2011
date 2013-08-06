//
//  TopPlacesTableViewController.m
//  TopPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPlacesPhotosTableViewController.h"

@interface TopPlacesTableViewController ()

@end

@implementation TopPlacesTableViewController

- (void)setTopPlaces:(NSArray *)topPlaces
{
    if (_topPlaces != topPlaces)
    {
        _topPlaces = topPlaces;
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
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    //download Data without blocking main thread
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *sort = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]];
        NSArray *data= [[FlickrFetcher topPlaces]sortedArrayUsingDescriptors:sort];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.topPlaces = data;
        });
    });
}
- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    // custom refresh logic
    {
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            NSArray *sort = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]];
            NSArray *data = [[FlickrFetcher topPlaces]sortedArrayUsingDescriptors:sort];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.topPlaces = data;
            });
        });
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    NSLog(@"TopPlaces %@", lastUpdated);
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UITableViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.topPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Place Description";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *topPlace = [self.topPlaces objectAtIndex:indexPath.row];
    NSString *placeFullName = [topPlace objectForKey:FLICKR_PLACE_NAME];
    NSArray *placeArray = [placeFullName componentsSeparatedByString:@", "];
    NSString *placeCityName = [placeArray objectAtIndex:0];
    NSString *placeRestName = [NSString stringWithFormat:@"%@",[placeArray objectAtIndex:1]];
    if (placeFullName && ![placeCityName isEqualToString:@""])
    {
        //set the title name
        cell.textLabel.text = placeCityName;
        cell.detailTextLabel.text = placeRestName;
        //set the title to Unknown
    }else
    {
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Invoked immediately prior to initiating a segue.
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSDictionary *place = [self.topPlaces objectAtIndex:path.row];
    [segue. destinationViewController setPlace:place];
}

@end
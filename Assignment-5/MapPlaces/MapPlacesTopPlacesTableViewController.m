//
//  MapPlacesTopPlacesTableViewController.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesTopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "MapPlacesPhotosInPlaceTableViewController.h"
#import "MapPlacesTopPlacesMapViewController.h"

@interface MapPlacesTopPlacesTableViewController () <MapPlacesTopPlacesMapViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *destinationPlace;

@end

@implementation MapPlacesTopPlacesTableViewController

-(void)setTopPlaces:(NSArray *)topPlaces
{
    if(_topPlaces != topPlaces)
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
    //for refresh
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSArray *sort = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:FLICKR_PLACE_NAME ascending:YES]];
        NSArray *data = [[FlickrFetcher topPlaces]sortedArrayUsingDescriptors:sort];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.topPlaces = data;
        });
    });
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
    NSString *placeRestName = [NSString stringWithFormat:@"%@", [placeArray objectAtIndex:1]];
    if (placeFullName && ![placeCityName isEqualToString:@""])
    {
        cell.textLabel.text = placeCityName;
        cell.detailTextLabel.text = placeRestName;
        // else set the title to Unknown
    } else
    {
        cell.textLabel.text = @"Unknown";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)segueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    self.destinationPlace = sender;
    NSLog(@"destinationPlace is %@", self.destinationPlace);
    [self performSegueWithIdentifier:identifier sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Table Cell"])
    {
        if (self.view.window)
        {
            //to check where the sague come from, if the TableViewController window is on screen,it's from cell
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            NSDictionary *place = [self.topPlaces objectAtIndex:path.row];
            [segue.destinationViewController setPlace:place];
        }else
        {
            // then it from map callout
            [segue.destinationViewController setPlace:self.destinationPlace];
        }
    } else if ([segue.identifier isEqualToString:@"Show Map"])
    {
        [segue.destinationViewController setTopPlaces:self.topPlaces];
        [segue.destinationViewController setDelegate:self];//after map showed, self is the delegate of mapViewController
    }
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    // custom refresh logic
    {
        dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL);
        dispatch_async(downloadQueue, ^{
            // Create a sorted array of place descriptions
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

@end

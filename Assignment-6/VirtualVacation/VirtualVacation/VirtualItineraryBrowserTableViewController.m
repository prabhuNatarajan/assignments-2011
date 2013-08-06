//
//  VirtualItineraryBrowserTableViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualItineraryBrowserTableViewController.h"
#import "Itinerary.h"
#import "VacationHelper.h"
#import "VirtualCoreDataPhotoListTableViewController.h"
#import "Place.h"

@interface VirtualItineraryBrowserTableViewController ()

@property (strong, nonatomic) Itinerary *itinerary;

@end

@implementation VirtualItineraryBrowserTableViewController

- (void)viewDidLoad
{
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSFetchedResultsController *)setupFetchControllerWithPlace:(NSString *)place
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"whereTaken.name = %@", place];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.document.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)setVacationName:(NSString *)vacationName
{
    _vacationName = vacationName;
    [VacationHelper openVacation:_vacationName withExtension:nil usingBlock:^(UIManagedDocument *vacation) {
        self.document = vacation;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Itinerary"];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSError *error = nil;
        self.itinerary = [[self.document.managedObjectContext executeFetchRequest:request error:&error] lastObject];
        if (!error)
        {
            [self.tableView reloadData];
            [self.tableView setEditing:YES animated:YES];
        }
        else
        {
            // error
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itinerary.places count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Itinerary Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[self.itinerary.places objectAtIndex:indexPath.row] name];
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    Place *sourcePlace = [self.itinerary.places objectAtIndex:fromIndexPath.row];
    NSMutableOrderedSet *places = [self.itinerary.places mutableCopy];
    [places removeObjectAtIndex:fromIndexPath.row];
    [places insertObject:sourcePlace atIndex:toIndexPath.row];
    self.itinerary.places = places;
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Place *place = [self.itinerary.places objectAtIndex:indexPath.row];
    
    VirtualCoreDataPhotosListTableViewController *cdpltvc = segue.destinationViewController;
    cdpltvc.fetchedResultsController = [self setupFetchControllerWithPlace:place.name];
}

@end

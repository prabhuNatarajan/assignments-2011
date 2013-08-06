//
//  VirtualTagBrowserTableViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualTagBrowserTableViewController.h"
#import "Tag.h"
#import "VirtualCoreDataPhotoListTableViewController.h"
#import "VacationHelper.h"

@interface VirtualTagBrowserTableViewController ()

@property (strong, nonatomic) UIManagedDocument *document;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation VirtualTagBrowserTableViewController

- (NSFetchedResultsController *)setupFetchControllerWithTag:(NSString *)tag
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"ANY tags.name LIKE[cd] %@", tag];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.document.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)setupFetchResultsController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tag"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"assignedPhotos" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.document.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)updateFetchResultsControllerWithPartialTagString:(NSString *)partialString
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", partialString];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"assignedPhotos" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.document.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // configuring search bar
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
}

- (void)setVacationName:(NSString *)vacationName
{
    _vacationName = vacationName;
    [VacationHelper openVacation:_vacationName withExtension:nil usingBlock:^(UIManagedDocument *vacation) {
        self.document = vacation;
        [self setupFetchResultsController];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tag Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = tag.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Photos : %@", tag.assignedPhotos];
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""]) [self setupFetchResultsController];
    else [self updateFetchResultsControllerWithPartialTagString:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    VirtualCoreDataPhotosListTableViewController *cdpltvc = segue.destinationViewController;
    cdpltvc.fetchedResultsController = [self setupFetchControllerWithTag:cell.textLabel.text];
}

@end

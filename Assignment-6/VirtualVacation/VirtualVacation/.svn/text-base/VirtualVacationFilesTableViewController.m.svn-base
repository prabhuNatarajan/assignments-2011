//
//  VirtualVacationFilesTableViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualVacationFilesTableViewController.h"
#import "VirtualVacationFileAddViewController.h"
#import "VacationHelper.h"
#import "VirtualCoreDataPhotoViewController.h"
#import "VirtualVacationBrowsingTypeTableViewController.h"

@interface VirtualVacationFilesTableViewController () <VirtualVacationFileAddDelegate>

@end

@implementation VirtualVacationFilesTableViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [VacationHelper getVacationsFilesWithExtension:nil usingBlock:^(BOOL success, NSArray *vacationFiles)
    {
        if (success && vacationFiles)
        {
            self.vacationFiles = [vacationFiles mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.navigationItem.leftBarButtonItem = self.editButtonItem;
                [self.tableView reloadData];
                if ([[[self.splitViewController viewControllers] lastObject] isKindOfClass:[VirtualCoreDataPhotoViewController class]])
                {
                    VirtualCoreDataPhotoViewController *cdpvc = [[self.splitViewController viewControllers] lastObject];
                    [cdpvc resetPhotoView];
                }
            });
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    if ([segue.destinationViewController isKindOfClass:[VirtualVacationFileAddViewController class]])
    {
        VirtualVacationFileAddViewController *vfavc = segue.destinationViewController;
        vfavc.delegate = self;
    }
    else if ([segue.destinationViewController isKindOfClass:[VirtualVacationBrowsingTypeTableViewController class]])
    {
        VirtualVacationBrowsingTypeTableViewController *vbtvc = segue.destinationViewController;
        vbtvc.vacationName = [VacationHelper getVacationNameFromURL:[self.vacationFiles objectAtIndex:indexPath.row]];
    }
}

#pragma mark - VacationFileAddDelegate protocol methods
- (BOOL)VirtualvacationFileAddViewController:(VirtualVacationFileAddViewController *)sender asksIfVacationWithGivenNameExists:(NSString *)name
{
    return [self.vacationFiles containsObject:[VacationHelper getVacationURL:name withExtension:nil]];
}

- (void)VirtualvacationFileAddViewController:(VirtualVacationFileAddViewController *)sender didAddVacation:(NSString *)vacationName
{
    if (vacationName)
    {
        [VacationHelper openVacation:vacationName withExtension:nil usingBlock:^(UIManagedDocument *vacation)
        {
            if (!self.vacationFiles) self.vacationFiles = [NSMutableArray array];
            [self.vacationFiles addObject:[VacationHelper getVacationURL:vacationName withExtension:nil]];
            [self.tableView reloadData];
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vacationFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation Files";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [VacationHelper getVacationNameFromURL:[self.vacationFiles objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // delete vacation file
        NSString *vacationName = [VacationHelper getVacationNameFromURL:[self.vacationFiles objectAtIndex:indexPath.row]];
        [VacationHelper removeVacation:vacationName usingCompletionHandler:^(BOOL success) {
            if (success)
            {
                [self.vacationFiles removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

@end

//
//  VirtualVacationFilesPopUpTableViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualVacationFilesPopUpTableViewController.h"

#define VACATIONS_POPUP_WIDTH 300

@interface VirtualVacationFilesPopupTableViewController ()

@end

@implementation VirtualVacationFilesPopupTableViewController

#pragma mark - Table view data source
- (void)reloadViewHeight
{
    CGRect sectionRect = [self.tableView rectForSection:0];
    self.contentSizeForViewInPopover = CGSizeMake(VACATIONS_POPUP_WIDTH, sectionRect.size.height);
}

- (void)setVacationNames:(NSArray *)vacationNames
{
    if (_vacationNames != vacationNames)
    {
        _vacationNames = vacationNames;
        [self.tableView reloadData];
        [self reloadViewHeight];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.vacationNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Vacation name cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.text = [self.vacationNames objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate)
    {
        [self.delegate VirtualVacationFilesPopupTableViewController:self didChooseVacation:[self.vacationNames objectAtIndex:indexPath.row]];
    }
}

@end

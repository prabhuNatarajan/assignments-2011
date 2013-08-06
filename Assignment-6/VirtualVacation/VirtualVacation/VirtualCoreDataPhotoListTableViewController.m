//
//  VirtualCoreDataPhotoListTableViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualCoreDataPhotoListTableViewController.h"
#import "ImageFetcher.h"
#import "Photo.h"
#import "VirtualCoreDataPhotoViewController.h"

@interface VirtualCoreDataPhotosListTableViewController ()

@end

@implementation VirtualCoreDataPhotosListTableViewController

- (void)getThumbnailForCell:(UITableViewCell *)cell usingURL:(NSURL *)url
{
    [ImageFetcher.sharedInstance getImageUsingURL:url completed:^(UIImage *image, NSData *data){
        if (!cell.imageView)
        {
            return;
        }
        if (image)
        {
            cell.imageView.image = image;
            [cell setNeedsLayout];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    if(cell.imageView.image) cell.imageView.image = nil;
    NSURL *thumbnailURL = [NSURL URLWithString:photo.thumbnailURL];
    [self getThumbnailForCell:cell usingURL:thumbnailURL];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    VirtualCoreDataPhotoViewController *coreDataPhotoViewController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    coreDataPhotoViewController.title = photo.title;
    coreDataPhotoViewController.isOnVacation = YES;
    coreDataPhotoViewController.document = self.document;
    coreDataPhotoViewController.vacationPhoto = photo;
}

@end

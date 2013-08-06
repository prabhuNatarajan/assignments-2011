//
//  VirtualPhotoListTableViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualPhotoListTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageFetcher.h"
#import "FlickerDataAnnotation.h"
#import "VirtualCoreDataPhotoViewController.h"
#import "VirtualMapViewController.h"

@interface VirtualPhotosListTableViewController ()

@end

@implementation VirtualPhotosListTableViewController

- (NSString *)getTitle:(NSDictionary *)photo
{
    NSString *title = [photo objectForKey:FLICKR_PHOTO_TITLE];
    NSString *subtitle = [self getSubtitle:photo];
    return [title isEqualToString:@""] ? (!subtitle || [subtitle isEqualToString:@""] ? @"Unknown" : subtitle): title;
}

- (NSString *)getSubtitle:(NSDictionary *)photo
{
    NSString *subtitle = [photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    return subtitle;
}

- (void)getThumbnailForCell:(UITableViewCell *)cell cellForRowAtIndexPath:(NSIndexPath *)indexpath usingPhotoData:(NSDictionary *)photo
{
    NSURL *thumbnailUrl = [FlickrFetcher urlForPhoto:photo format:FlickrPhotoFormatSquare];
    //NSString *key = [thumbnailUrl path];
    //NSData *imageData = [NSData dataWithContentsOfURL:thumbnailUrl];
    //[ImageFetcher.sharedInstance getImageUsingURL:(NSURL *)thumbnailUrl usingCacheForKey:(NSString *)key completed:^(UIImage *image,NSData *data){
     [ImageFetcher.sharedInstance getImageUsingURL:thumbnailUrl completed:^(UIImage *image, NSData *data){
        UITableViewCell *cell  = [self.tableView cellForRowAtIndexPath:indexpath];
        if (!cell.imageView)
        {
            return;
            [self getThumbnailForCell:cell cellForRowAtIndexPath:indexpath usingPhotoData:photo];
        }
        if (image)
        {
            cell.imageView.image = image;
            [cell setNeedsLayout];
        }
    }];
}

 #pragma mark - prepare annotations for map view - <MKAnnotation> elements
- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos)
    {
        [annotations addObject:[FlickrDataAnnotation annotationForData:photo usingTitle:[self getTitle:photo] andSubtitle:[self getSubtitle:photo] usingPinPadding:YES usingThumbnail:YES]];
    }
    return annotations;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *photo = [self.photos objectAtIndex:indexPath.row];
    cell.textLabel.text = [self getTitle:photo];
    cell.detailTextLabel.text = [self getSubtitle:photo];
    if (cell.imageView.image)
    {
        cell.imageView.image = nil;
    }
    [self getThumbnailForCell:cell cellForRowAtIndexPath:indexPath usingPhotoData:photo];
    return cell;
}

- (void)setPhotos:(NSArray *)photos
{
    if (_photos != photos)
    {
        _photos = photos;
    }
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
 if ([[segue destinationViewController] respondsToSelector:@selector(setPhoto:)])
    {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        //NSLog(@"%@",path);
        NSDictionary *photo = [self.photos objectAtIndex:path.row];
        [segue.destinationViewController setTitle:[self getTitle:photo]];
        [segue.destinationViewController setPhoto:photo];
    }
    else if ([[segue destinationViewController] respondsToSelector:@selector(setAnnotations:)])
    {
        if (self.photos)
        {
            [[segue destinationViewController] setAnnotations:[self mapAnnotations]];
        }
        [[segue destinationViewController] setActivityIndicator:self.activityIndicator];
    }
}

@end

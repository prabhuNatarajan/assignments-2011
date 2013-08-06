//
//  TopPlacesRecentPlaces.m
//  TopPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "TopPlacesRecentPlaces.h"
#import "FlickrFetcher.h"

@implementation TopPlacesRecentPlaces

+ (NSArray *)retrieveRecentsUserDefaults
{
    NSUserDefaults *recentsUserDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *photos;
    photos = [recentsUserDefaults arrayForKey:@"Recents Viewed Photos"];
    return photos;
}

+ (void)saveRecentsUserDefaults:(NSDictionary *)photo
{
    NSUserDefaults *recentsUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *photosMutalbeCopy = [[recentsUserDefaults arrayForKey:@"Recents Viewed Photos"] mutableCopy];
    if (!photosMutalbeCopy)
    {
        photosMutalbeCopy = [NSMutableArray array];
    }
    //to maintain unique photos
    NSString *newPhotoID = [photo valueForKey:FLICKR_PHOTO_ID];
    for (int i=0; i<[photosMutalbeCopy count]; i++)
    {
        NSString *oldPhotoID = [[photosMutalbeCopy objectAtIndex:i] valueForKey:FLICKR_PHOTO_ID];
        if ([newPhotoID isEqualToString:oldPhotoID]) [photosMutalbeCopy removeObjectAtIndex:i];
    }
    [photosMutalbeCopy insertObject:photo atIndex:0];
    NSArray *photos = [photosMutalbeCopy copy];
    //set the maximum counts
    if ([photos count] > Maximum_limit)
    {
        NSRange range;
        range.location = 0;
        range.length = Maximum_limit;
        photos = [photos subarrayWithRange:range];
    }
    [recentsUserDefaults setValue:photos forKey:@"Recents Viewed Photos"];
    [recentsUserDefaults synchronize];
}

@end
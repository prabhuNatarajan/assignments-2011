//
//  MapPlacesRecentPlaces.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesRecentPlaces.h"
#import "FlickrFetcher.h"

@implementation MapPlacesRecentPlaces

+ (NSArray *)retrieveRecentUserDefaults
{
    NSUserDefaults *recentUserDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *photos;
    photos = [recentUserDefaults arrayForKey:@"Recents Viewed Photos"];
    return photos;
}

+ (void)saveRecentUserDefaults:(NSDictionary *)photo
{
    NSUserDefaults *recentUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *photosMutalbeCopy = [[recentUserDefaults arrayForKey:@"Recents Viewed Photos"] mutableCopy];
    if (!photosMutalbeCopy)
    {
        photosMutalbeCopy = [NSMutableArray array];
    }
    //to avoid duplex photo copy
    NSString *newPhotoID = [photo valueForKey:FLICKR_PHOTO_ID];
    for (int i=0; i<[photosMutalbeCopy count]; i++)
    {
        NSString *oldPhotoID = [[photosMutalbeCopy objectAtIndex:i] valueForKey:FLICKR_PHOTO_ID];
        if ([newPhotoID isEqualToString:oldPhotoID]) [photosMutalbeCopy removeObjectAtIndex:i];
    }
    [photosMutalbeCopy insertObject:photo atIndex:0];    
    NSArray *photos = [photosMutalbeCopy copy];
    if ([photos count]>RECENTS_PHOTO_AMOUNT)
    {
        NSRange range;
        range.location = 0;
        range.length = RECENTS_PHOTO_AMOUNT;
        photos = [photos subarrayWithRange:range];
    }
    [recentUserDefaults setValue:photos forKey:@"Recents Viewed Photos"];
    [recentUserDefaults synchronize];
}

@end

//
//  MapPlacesRecentPlaces.h
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RECENTS_PHOTO_AMOUNT 20

@interface MapPlacesRecentPlaces : NSObject

+ (NSArray *)retrieveRecentUserDefaults;
+ (void)saveRecentUserDefaults:(NSDictionary *)photo;

@end
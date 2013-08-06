//
//  TopPlacesRecentPlaces.h
//  TopPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Maximum_limit 50

@interface TopPlacesRecentPlaces : NSObject

+ (NSArray *)retrieveRecentsUserDefaults;
+ (void)saveRecentsUserDefaults:(NSDictionary *)photo;

@end

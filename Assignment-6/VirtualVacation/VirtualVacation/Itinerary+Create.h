//
//  Itinerary+Create.h
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Itinerary.h"

@interface Itinerary (Create)

+ (Itinerary *)itineraryInManagedObjectContext:(NSManagedObjectContext *)context;

@end

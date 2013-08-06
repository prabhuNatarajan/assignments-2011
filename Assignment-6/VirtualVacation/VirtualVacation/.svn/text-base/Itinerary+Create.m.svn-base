//
//  Itinerary+Create.m
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "Itinerary+Create.h"

#define ITENERARY_LABEL @"Itinerary"

@implementation Itinerary (Create)

+ (Itinerary *)itineraryInManagedObjectContext:(NSManagedObjectContext *)context
{
    Itinerary *itinerary = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Itinerary"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error = nil;
    NSArray *itineraries = [context executeFetchRequest:request error:&error];
    if (error)
    {
        //error!
    }
    
    if (!itineraries || [itineraries count] > 1)
    {
        // error
    } else if (![itineraries count])
    {
        itinerary = [NSEntityDescription insertNewObjectForEntityForName:@"Itinerary" inManagedObjectContext:context];
        itinerary.name = ITENERARY_LABEL;
    } else
    {
        itinerary = [itineraries lastObject];
    }
    return itinerary;
}

@end

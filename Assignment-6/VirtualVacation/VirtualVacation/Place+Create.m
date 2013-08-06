//
//  Place+Create.m
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "Place+Create.h"
#import "Itinerary+Create.h"

@implementation Place (Create)

+ (Place *)PlaceWithDescription:(NSString *)placeDescription inManagedObjectContext:(NSManagedObjectContext *)context
{
    Place *place = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Place"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", placeDescription];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error = nil;
    NSArray *places = [context executeFetchRequest:request error:&error];
    if (!places || [places count] > 1)
    {
        // error!!
    } else if (![places count])
    {
        place = [NSEntityDescription insertNewObjectForEntityForName:@"Place" inManagedObjectContext:context];
        place.name = placeDescription;
        place.itinerary = [Itinerary itineraryInManagedObjectContext:context];
    } else
    {
        place = [places lastObject];
    }
    return place;
}

@end

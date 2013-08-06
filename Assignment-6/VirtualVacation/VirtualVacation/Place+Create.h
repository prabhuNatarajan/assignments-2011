//
//  Place+Create.h
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Place.h"

@interface Place (Create)

+ (Place *)PlaceWithDescription:(NSString *)placeDescription inManagedObjectContext:(NSManagedObjectContext *)context;

@end

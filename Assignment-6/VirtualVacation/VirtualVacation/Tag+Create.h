//
//  Tag+Create.h
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Tag.h"

@interface Tag (Create)

+ (NSSet *)tagsFromString:(NSString *)tagsString inManagedObjectContext:(NSManagedObjectContext *)context;

@end

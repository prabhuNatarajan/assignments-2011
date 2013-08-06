//
//  Tag+Create.m
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "Tag+Create.h"


@implementation Tag (Create)

+ (Tag *)tagWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Tag *tag = nil;
    tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag" inManagedObjectContext:context];
    tag.name = name;
    tag.assignedPhotos = [NSNumber numberWithInt:1];
    return tag;
}

+ (NSSet *)tagsFromString:(NSString *)tagsString inManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableSet *tags = nil;
    if (![tagsString length])
    {
        return nil;
    }
    NSMutableArray *tagsArray = [[[tagsString componentsSeparatedByString:@" "] valueForKey:@"capitalizedString"] mutableCopy];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tag"];
    request.predicate = [NSPredicate predicateWithFormat:@"name IN %@", tagsArray];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSError *error = nil;
    NSArray *fetchedTags = [context executeFetchRequest:request error:&error];
    if (!fetchedTags)
    {
        // error
    } else if (![fetchedTags count])
    {
        // tags don't exists - create new entries
        for (NSString *tagName in tagsArray)
        {
            // ignore tags containing ',' character - Requred Tasks #4
            if ([tagName rangeOfString:@":"].location == NSNotFound)
            {
                Tag *tag = [Tag tagWithName:tagName inManagedObjectContext:context];
                if (!tags)
                {
                    tags = [NSMutableSet new];
                }
                [tags addObject:tag];
            }
        }
    } else
    {
        if (!tags)
        {
            tags = [NSMutableSet new];
        }
        for (Tag *tag in fetchedTags)
        {
            if ([tagsArray containsObject:tag.name])
            {
                NSUInteger index = [tagsArray indexOfObject:tag.name];
                tag.assignedPhotos = [NSNumber numberWithInt:[tag.assignedPhotos intValue] + 1];
                [tagsArray removeObjectAtIndex:index];
                [tags addObject:tag];
            }
        }
        if ([tagsArray count])
        {
            for(NSString *tagName in tagsArray)
            {
                Tag *tag = [Tag tagWithName:tagName inManagedObjectContext:context];
                [tags addObject:tag];
            }
        }
    }
    return tags;
}

@end


//
//  Photo+Flickr.m
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "Photo+Flickr.h"
#import "Place+Create.h"
#import "Tag+Create.h"
#import "FlickrFetcher.h"

@implementation Photo (Flickr)

+ (NSFetchRequest *)setupPhotoFetchRequestWithKey:(NSString *)key
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", key];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    return request;
}

+ (Photo *)photoWithDictionaryInfo:(NSDictionary *)flickrInfo inManagedObjectContext:(NSManagedObjectContext *)context
{
    Photo *photo = nil;
    NSFetchRequest *request = [self setupPhotoFetchRequestWithKey:[flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || [matches count] > 1)
    {
        // Error
    }
    else if ([matches count] == 0)
    {
        photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
        photo.unique = [flickrInfo objectForKey:FLICKR_PHOTO_ID];
        photo.title = [flickrInfo objectForKey:FLICKR_PHOTO_TITLE];
        photo.url = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatLarge] absoluteString];
        photo.thumbnailURL = [[FlickrFetcher urlForPhoto:flickrInfo format:FlickrPhotoFormatSquare] absoluteString];
        photo.whereTaken = [Place PlaceWithDescription:[flickrInfo objectForKey:FLICKR_PHOTO_PLACE_NAME] inManagedObjectContext:context];
        photo.tags = [Tag tagsFromString:[flickrInfo objectForKey:FLICKR_TAGS] inManagedObjectContext:context];
    }
    return photo;
}

+ (Photo *)photoWithDictionaryInfo:(NSDictionary *)flickrInfo existsInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self setupPhotoFetchRequestWithKey:[flickrInfo objectForKey:FLICKR_PHOTO_ID]];
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    if (!matches || [matches count] > 1)
    {
        abort();
    } else if([matches count] == 1)
    {
        return [matches lastObject];
    }
    return nil;
}

- (void)prepareForDeletion
{
    NSManagedObjectContext *context = self.managedObjectContext;
    // manage tags associated to the 'soon to be deleted' photo
    if (self.tags)
    {
        for (Tag *tag in self.tags)
        {
            if ([tag.photos count] == 1) [context deleteObject:tag];
            else tag.assignedPhotos = [NSNumber numberWithInt:[tag.photos count] - 1];
        }
    }
    if ([self.whereTaken.photos count] == 1)
    {
        [context deleteObject:self.whereTaken];
    }
}

@end
//
//  VacationHelper.m
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VacationHelper.h"

#define DEFAULT_VACATION_NAME @"MyVacation"
#define DEFAULT_EXTENSION @"vacation"

static NSMutableDictionary *vacationDocuments = nil;

@implementation VacationHelper

+ (void)openVacation:(NSString *)vacationName withExtension:(NSString *)extension usingBlock:(completion_block_t)block
{
    if (!vacationName) vacationName = DEFAULT_VACATION_NAME;
    UIManagedDocument *vacationDatabase = [vacationDocuments objectForKey:vacationName];
    if (!vacationDatabase)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *vacationURL = [self getVacationURL:vacationName withExtension:extension];
        UIManagedDocument *document = [[UIManagedDocument alloc] initWithFileURL:vacationURL];
        
        if (![fileManager fileExistsAtPath:[document.fileURL path]])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success){
                    if (!vacationDocuments) vacationDocuments = [NSMutableDictionary dictionary];
                    [vacationDocuments setObject:document forKey:vacationName];
                    block(document);
                }];
                
            });
        } else
        {
            // error - this shouldn't happen
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (vacationDatabase.documentState == UIDocumentStateClosed) {
                [vacationDatabase openWithCompletionHandler:^(BOOL success) {
                    if (success)
                    {
                        block(vacationDatabase);
                    }
                }];
            } else if (vacationDatabase.documentState == UIDocumentStateNormal)
            {
                block(vacationDatabase);
            } else
            {
                block(nil);
            }
        });
    }
}

+ (NSURL *)getVacationsDirectoryURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)getVacationURL:(NSString *)vacationName withExtension:(NSString *)extension
{
    NSURL *vacationURL = [[self getVacationsDirectoryURL] URLByAppendingPathComponent:vacationName];
    return [[vacationURL URLByAppendingPathExtension:(extension ? extension : DEFAULT_EXTENSION)] URLByAppendingPathComponent:@"/"];
}

+ (NSString *)getVacationNameFromURL:(NSURL *)url
{
    return [[url lastPathComponent] stringByDeletingPathExtension];
}

+ (void)prepareVacationDocuments:(NSArray *)documentFilesList
{
    if (!vacationDocuments) vacationDocuments = [NSMutableDictionary dictionary];
    for(NSURL *url in documentFilesList)
    {
        UIManagedDocument *doc = [[UIManagedDocument alloc] initWithFileURL:url];
        [vacationDocuments setObject:doc forKey:[self getVacationNameFromURL:url]];
    }
}

+ (void)getVacationsFilesWithExtension:(NSString *)extension usingBlock:(vacation_list_completion_block_t)block
{
    dispatch_queue_t diskQ = dispatch_queue_create("Vacation files", NULL);
    if (!extension)
    {
        extension = DEFAULT_EXTENSION;
    }
    dispatch_async(diskQ, ^{
        NSMutableArray *vacationFiles = [NSMutableArray array];
        NSURL *vacationsFilesDirectoryURL = [self getVacationsDirectoryURL];
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *files = [fileManager contentsOfDirectoryAtURL:vacationsFilesDirectoryURL includingPropertiesForKeys:[NSArray arrayWithObject:NSURLNameKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        for (NSURL *url in files)
        {
            if ([[url pathExtension] isEqualToString:extension])
            {
                [vacationFiles addObject:url];
            }
        }
        if ([vacationFiles count])
        { 
            if (!vacationDocuments)
            {
                [self prepareVacationDocuments:vacationFiles];
                if (block) block(YES, vacationFiles);
            }
            else
            {
                if (block) block(YES,vacationFiles);
            }
        }
        else
        {
            if (block) block(YES, nil);
        }
    });
}

+ (NSString *)getCurrentVacation
{
    if ([vacationDocuments count] == 1)
    {
        return [[vacationDocuments allKeys] lastObject];
    }
    return nil;
}

+ (NSArray *)getVacations
{
    NSArray *vacations = [vacationDocuments allKeys];
    return [vacations count] ? vacations : nil;
}

+ (void)removeVacation:(NSString *)vacation usingCompletionHandler:(remove_vacation_completion_handler_t)handler
{
    dispatch_queue_t removeQ = dispatch_queue_create("Remove vacation file", NULL);
    dispatch_async(removeQ, ^{
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([vacationDocuments objectForKey:vacation])
        {
            __block UIManagedDocument *document = [vacationDocuments objectForKey:vacation];
            [fileManager removeItemAtURL:document.fileURL error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error)
                {
                    [vacationDocuments removeObjectForKey:vacation];
                    document = nil;
                    handler(YES);
                }
                else
                {
                    handler(NO);
                }
            });
        }
    });
}

@end

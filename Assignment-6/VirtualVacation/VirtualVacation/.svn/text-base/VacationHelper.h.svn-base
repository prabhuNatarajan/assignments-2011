//
//  VacationHelper.h
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_VACATION_FILES 50

typedef void (^vacation_file_saved_block_t)(BOOL success);
typedef void (^completion_block_t)(UIManagedDocument *vacation);
typedef void (^remove_vacation_completion_handler_t)(BOOL success);
typedef void (^vacation_list_completion_block_t)(BOOL success, NSArray *vacationFiles);

@interface VacationHelper : NSObject

+ (void)openVacation:(NSString *)vacationName withExtension:(NSString *)extension usingBlock:(completion_block_t)block;
+ (void)removeVacation:(NSString *)vacation usingCompletionHandler:(remove_vacation_completion_handler_t)handler;
+ (void)getVacationsFilesWithExtension:(NSString *)extension usingBlock:(vacation_list_completion_block_t)block;
+ (NSURL *)getVacationURL:(NSString *)vacationName withExtension:(NSString *)extension;
+ (NSString *)getVacationNameFromURL:(NSURL *)url;
+ (NSString *)getCurrentVacation;
+ (NSArray *)getVacations;

@end

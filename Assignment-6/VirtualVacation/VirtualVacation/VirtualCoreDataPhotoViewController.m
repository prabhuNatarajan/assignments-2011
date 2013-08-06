//
//  VirtualCoreDataPhotoViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualCoreDataPhotoViewController.h"
#import "VacationHelper.h"
#import "FlickrFetcher.h"
#import "ImageFetcher.h"
#import "Photo+Flickr.h"

#define VISIT_LABEL @"Visit"
#define UNVISIT_LABEL @"UnVisit"

@interface VirtualCoreDataPhotoViewController () <UIPopoverControllerDelegate>

@property (nonatomic, strong) Photo *coreDataPhoto;

@end

@implementation VirtualCoreDataPhotoViewController

- (void)VirtualVacationFilesPopupTableViewController:(VirtualVacationFilesPopupTableViewController *)sender didChooseVacation:(NSString *)vacation
{
    [VacationHelper openVacation:vacation withExtension:nil usingBlock:^(UIManagedDocument *vacation) {
        // we're now in the main thread
        if (![Photo photoWithDictionaryInfo:self.photo existsInManagedObjectContext:vacation.managedObjectContext])
        {
            [Photo photoWithDictionaryInfo:self.photo inManagedObjectContext:vacation.managedObjectContext];
            [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                if (success)
                {
                    [self.popover dismissPopoverAnimated:YES];
                    self.popover = nil;
                }
            }];
        } else
        {
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
        }
    }];
}

- (void)showAvailableVacationsPopup:(NSArray *)vacations animated:(BOOL)animated
{
    // attach popup to visit button and display it
    if (vacations)
    {
        if (self.popover)
        {
            [self.popover dismissPopoverAnimated:YES];
            self.popover = nil;
            return;
        }
        else
        {
            if (!self.popoverData)
            {
                self.popoverData = [[VirtualVacationFilesPopupTableViewController alloc] initWithStyle:UITableViewStylePlain];
                self.popoverData.delegate = self;
                self.popoverData.vacationNames = vacations;
            }
            UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:self.popoverData];
            self.popover = popoverController;
            [popoverController presentPopoverFromBarButtonItem:self.visitButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else
    {
        // error!
    }
}

- (void)visitPressed
{
    __block BOOL isVisited;
    if (self.isOnVacation)
    {
        if (self.vacationPhoto)
        {
            [self.vacationPhoto.managedObjectContext deleteObject:self.vacationPhoto];
            self.vacationPhoto = nil;
            [self resetPhotoView];
            [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {}];
        }
    } else if (self.vacationName)
    {
        [VacationHelper openVacation:self.vacationName withExtension:nil usingBlock:^(UIManagedDocument *vacation)
        {
            if ([self.visitButton.title isEqualToString:VISIT_LABEL])
            {
                self.coreDataPhoto = [Photo photoWithDictionaryInfo:self.photo inManagedObjectContext:vacation.managedObjectContext];
                isVisited = YES;
            }
            else
            {
                // remove photo from vacation
                if (self.coreDataPhoto)
                {
                    [self.coreDataPhoto.managedObjectContext deleteObject:self.coreDataPhoto];
                    self.coreDataPhoto = nil;
                    isVisited = NO;
                }
            }
            [vacation saveToURL:vacation.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                if (success)
                {
                    self.visitButton.title = isVisited ? UNVISIT_LABEL : VISIT_LABEL;
                }
            }];
        }];
    }
    else
    {
        //display popup with available vacation files
        [self showAvailableVacationsPopup:self.vacations animated:YES];
    }
}

- (void)resetPhotoView
{
    [super resetPhotoView];
    if (self.visitButton)
    {
        [self clearVisitButton];
    }
}

- (void)clearVisitButton
{
    if (self.visitButton)
    {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if ([toolbarItems containsObject:self.visitButton])
        {
            [toolbarItems removeObject:self.visitButton];
            self.toolbar.items = toolbarItems;
        }
    }
}

- (void)addVisitButton
{
    if (self.visitButton)
    {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        [toolbarItems addObject:self.visitButton];
        self.toolbar.items = toolbarItems;
    }
}

- (void)loadPhoto
{
    NSURL *photoURL;
    NSString *photoID;
    if (!self.isOnVacation)
    {
        photoURL = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        photoID = [self.photo objectForKey:FLICKR_PHOTO_ID];
    }
    else
    {
        photoURL = [NSURL URLWithString:self.vacationPhoto.url];
        photoID = self.vacationPhoto.unique;
    }
    [self.downloadIndicator startAnimating];
    [ImageFetcher.sharedInstance getImageUsingURL:photoURL usingCacheForKey:photoID completed:^(UIImage *image, NSData *data){
        if (!self.isOnVacation)
        {
            if ([photoID isEqualToString:[self.photo objectForKey:FLICKR_PHOTO_ID]])
            {
                [self updateViewWithImage:image];
                [self storePhoto];
            }
        } else
        {
            [self updateViewWithImage:image];
        }
        [self.downloadIndicator stopAnimating];
    }];
}

- (void)setupVisitButton
{
    if (!self.visitButton)
    {
        self.visitButton = [[UIBarButtonItem alloc] initWithTitle:VISIT_LABEL style:UIBarButtonItemStyleBordered target:self action:@selector(visitPressed)];
    }
    if (self.isOnVacation)
    {
        self.visitButton.title = UNVISIT_LABEL;
        [self addVisitButton];
        return;
    }
    self.vacationName = [VacationHelper getCurrentVacation];
    if (self.vacationName)
    {
        [VacationHelper openVacation:self.vacationName withExtension:nil usingBlock:^(UIManagedDocument *vacation) {
            // we're now in the main thread
            if ((self.coreDataPhoto = [Photo photoWithDictionaryInfo:self.photo existsInManagedObjectContext:vacation.managedObjectContext]))
            {
                self.visitButton.title = UNVISIT_LABEL;
            } else
            {
                self.visitButton.title = VISIT_LABEL;
            }
            [self addVisitButton];
        }];
    }
    else
    {
        self.vacations = [VacationHelper getVacations];
        self.visitButton.title = VISIT_LABEL;
        [self addVisitButton];
    }
    if (!self.vacationName && !self.vacations)
    {
        [VacationHelper openVacation:nil withExtension:nil usingBlock:^(UIManagedDocument *vacation) {
            self.vacationName = [VacationHelper getCurrentVacation];
            self.visitButton.title = VISIT_LABEL;
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.imageView.image && !self.photo && !self.isOnVacation)
    {
        [self resetPhotoView];
    } else
    {
        [self loadPhoto];
        [self setupVisitButton];
    }
    if (self.title)
    {
        if (self.titleBarButtonItem)
        {
            self.titleBarButtonItem.title = self.title;
        }
    }
}

@end

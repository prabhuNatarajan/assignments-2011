//
//  MapPlacesPhotosInPlaceMapViewController.h
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MapPlacesPhotosInPlaceMapViewController;

@protocol MapPlacesPhotosInPlaceMapViewControllerDelegate <NSObject>

- (void)segueWithIdentifier:(NSString *)identifier sender:(id)sender;
- (UIImage *)MapPlacesPhotosInPlaceMapViewController:(MapPlacesPhotosInPlaceMapViewController *)sender imageForAnnotation:(id <MKAnnotation>) annotation;

@end

@interface MapPlacesPhotosInPlaceMapViewController : UIViewController

@property (nonatomic, strong) NSArray *photos;//sagued from PhotosInPlaceTableViewController
@property (nonatomic, weak) id <MapPlacesPhotosInPlaceMapViewControllerDelegate> delegate;

@end

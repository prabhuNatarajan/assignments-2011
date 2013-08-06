//
//  MapPlacesTopPlacesMapViewController.h
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapPlacesTopPlacesMapViewControllerDelegate <NSObject>

- (void)segueWithIdentifier:(NSString *)identifier sender:(id)sender;

@end

@interface MapPlacesTopPlacesMapViewController : UIViewController

@property (nonatomic,strong) NSArray *topPlaces;//sagued from TopPlacesTableViewController
@property (nonatomic,weak) id <MapPlacesTopPlacesMapViewControllerDelegate> delegate;

@end

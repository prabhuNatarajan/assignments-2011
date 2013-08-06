//
//  MapPlacesPhotosInPlaceTableViewController.h
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapPlacesPhotosInPlaceTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *place;
@property (nonatomic, strong) NSArray *photos;

@end

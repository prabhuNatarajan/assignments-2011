//
//  VirtualMapViewController.h
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface VirtualMapViewController : UIViewController

@property (strong, nonatomic) NSArray *annotations; //of id <MKAnnotation>
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end


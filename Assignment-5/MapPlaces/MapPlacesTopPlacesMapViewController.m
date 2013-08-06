//
//  MapPlacesTopPlacesMapViewController.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesTopPlacesMapViewController.h"
#import "FlickrFetcher.h"
#import "MapPlacesTopPlaceAnnotation.h"

@interface MapPlacesTopPlacesMapViewController() <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) NSArray *annotations;

@end

@implementation MapPlacesTopPlacesMapViewController

- (void)updateMapView
{
    if (self.mapView.annotations)
    {
        [self.mapView removeAnnotations:self.mapView.annotations];
    }
    if (self.annotations)
    {
        [self.mapView addAnnotations:self.annotations];
    }
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapView = mapView;
    [self updateMapView];
}

- (void)setAnnotations:(NSArray *)annotations
{
    _annotations = annotations;
    [self updateMapView];
}

- (NSArray *)mapAnnotations
{
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.topPlaces count]];
    for (NSDictionary *topPlace in self.topPlaces)
    {
        [annotations addObject:[MapPlacesTopPlaceAnnotation annotationForTopPlace:topPlace]];
    }
    return annotations;
}

- (void)setTopPlaces:(NSArray *)topPlaces
{
    _topPlaces = topPlaces;
    self.annotations = [self mapAnnotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapViewController"];
    if (!aView)
    {
        aView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MapViewController"];
        aView.canShowCallout = YES;
        aView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    aView.annotation = annotation;
    return aView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapPlacesTopPlaceAnnotation *annotation = (MapPlacesTopPlaceAnnotation *)view.annotation;
    NSDictionary *topPlace = annotation.topPlace;
    NSLog(@"topPlace is %@",topPlace);
    [self.delegate segueWithIdentifier:@"Show Table Cell" sender:topPlace];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self; //disclosure button will be shown
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end

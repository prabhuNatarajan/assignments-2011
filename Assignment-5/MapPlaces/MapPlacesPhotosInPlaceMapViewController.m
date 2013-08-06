//
//  MapPlacesPhotosInPlaceMapViewController.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesPhotosInPlaceMapViewController.h"
#import "MapPlacesPhotosInPlaceAnnotation.h"
#import "MapPlacesRecentPlaces.h"

@interface MapPlacesPhotosInPlaceMapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong)NSArray *annotations;//of id <MKAnnotation, by reading property photos
@end

@implementation MapPlacesPhotosInPlaceMapViewController

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
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[self.photos count]];
    for (NSDictionary *photo in self.photos)
    {
        [annotations addObject:[MapPlacesPhotosInPlaceAnnotation annotationForPhoto:photo]];
    }
    return annotations;
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
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
        aView.leftCalloutAccessoryView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    return aView;
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr thumbnail downloader", NULL);
    dispatch_async(downloadQueue, ^{
        //[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];//simulated network latency
        UIImage *image = [self.delegate MapPlacesPhotosInPlaceMapViewController:self imageForAnnotation:aView.annotation];
        dispatch_async(dispatch_get_main_queue(), ^{
            [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
            
        });
    });
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    MapPlacesPhotosInPlaceAnnotation *annotation = (MapPlacesPhotosInPlaceAnnotation *)view.annotation;
    NSDictionary *photo = annotation.photo;
    [self.delegate segueWithIdentifier:@"Show Table Cell" sender:photo];
    [MapPlacesRecentPlaces saveRecentUserDefaults:photo];
}


- (void)viewWillAppear:(BOOL)animated
{
    MKMapRect regionToDisplay = [self mapRectForAnnotations:self.annotations];
    if (!MKMapRectIsNull(regionToDisplay)) self.mapView.visibleMapRect = regionToDisplay;
}

// Position the map so that all overlays and annotations are visible on screen.
- (MKMapRect) mapRectForAnnotations:(NSArray*)annotations
{
    MKMapRect mapRect = MKMapRectNull;
    
    //annotations is an array with all the annotations I want to display on the map
    for (id<MKAnnotation> annotation in annotations)
    {        
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(mapRect))
        {
            mapRect = pointRect;
        } else
        {
            mapRect = MKMapRectUnion(mapRect, pointRect);
        }
    }
    return mapRect;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end

//
//  VirtualMapViewController.m
//  VirtualVacation
//
//  Created by Apple on 14/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "VirtualMapViewController.h"
#import "FlickerDataAnnotation.h"
#import "FlickrFetcher.h"
#import "VirtualPhotoViewController.h"
#import "ImageFetcher.h"
#import "VirtualTopRatedPlacesTableViewController.h"
#import "VirtualPhotoListTableViewController.h"
#import "VirtualPhotosInPlaceViewController.h"

//pin padding in pixels
static int pinPadding = 5;

typedef enum {
    MapViewTypeNormal,
    MapViewTypeSatellite,
    MapViewTypeHybrid
} MapViewTypes;

@interface VirtualMapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation VirtualMapViewController

- (IBAction)segmentedControllerMapTypeValueChanged:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch(segmentedControl.selectedSegmentIndex)
    {
        case MapViewTypeNormal:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case MapViewTypeSatellite:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        case MapViewTypeHybrid:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            self.mapView.mapType = MKMapTypeStandard;
            break;
    }
}

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.segmentedControl)
    {
        self.segmentedControl.selectedSegmentIndex = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.mapView.delegate = self;
    // check if map region should be matched to pins location
    FlickrDataAnnotation *annotation = [self.annotations objectAtIndex:0];
    if (annotation.usePinPadding)
    {
        MKMapRect boundingRect = MKMapRectNull;
        NSUInteger i = 0;
        for (FlickrDataAnnotation *fda in self.annotations)
        {
            MKMapPoint mapPoint = MKMapPointForCoordinate(fda.coordinate);
            MKMapRect pointRect = MKMapRectMake(mapPoint.x, mapPoint.y, pinPadding, pinPadding);
            if (i == 0)
            {
                boundingRect = pointRect;
            } else
            {
                boundingRect = MKMapRectUnion(boundingRect, pointRect);
            }
            i++;
        }
        [self.mapView setVisibleMapRect:boundingRect animated:YES];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    FlickrDataAnnotation *fda = annotation;
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView)
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        
        if (fda.useAnnotationThumbnail)
        {
            aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        }
    }
    aView.annotation = annotation;
    if (fda.useAnnotationThumbnail)
    {
        [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    }
    UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    aView.rightCalloutAccessoryView = disclosureButton;
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    FlickrDataAnnotation *fda = aView.annotation;
    if (fda.useAnnotationThumbnail)
    {
        NSURL *annotationThumbUrl = [FlickrFetcher urlForPhoto:fda.data format:FlickrPhotoFormatSquare];
        [ImageFetcher.sharedInstance getImageUsingURL:annotationThumbUrl completed:^(UIImage *image, NSData *data){
            // check if annotation is still visible
            NSArray *selectedAnnotations = self.mapView.selectedAnnotations;
            if (selectedAnnotations != nil && ([self.mapView.selectedAnnotations indexOfObject:aView.annotation] != NSNotFound ))
            {
                [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
            }
        }];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    FlickrDataAnnotation *fda = view.annotation;
    if (fda.useAnnotationThumbnail)
    {
        [self performSegueWithIdentifier:@"Map To Photo Viewer" sender:view];
    }
    else
    {
        [self performSegueWithIdentifier:@"Map To Photos Table View" sender:view];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MKAnnotationView *annotation = sender;
    //PhotosListTableViewController subclass
    if ([[segue identifier] isEqualToString:@"Map To Photos Table View"])
    {
        FlickrDataAnnotation *annotationData = annotation.annotation;
        [[segue destinationViewController] setPlace:annotationData.data];
        [[segue destinationViewController] setTitle:annotationData.title];
        [[segue destinationViewController] setActivityIndicator:self.activityIndicator];
    }
    //PhotoViewController
    if ([[segue identifier] isEqualToString:@"Map To Photo Viewer"])
    {
        FlickrDataAnnotation *annotataionData = annotation.annotation;
        [segue.destinationViewController setTitle:annotataionData.title];
        [segue.destinationViewController setPhoto:annotataionData.data];
    }
}

@end

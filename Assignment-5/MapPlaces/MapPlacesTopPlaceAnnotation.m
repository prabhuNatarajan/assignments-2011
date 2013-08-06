//
//  MapPlacesTopPlaceAnnotation.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesTopPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation MapPlacesTopPlaceAnnotation

+ (MapPlacesTopPlaceAnnotation *)annotationForTopPlace:(NSDictionary *)topPlace
{
    MapPlacesTopPlaceAnnotation *annotation = [[MapPlacesTopPlaceAnnotation alloc]init];
    annotation.topPlace = topPlace;
    return annotation;
}

- (NSString *)title
{
    return [self.topPlace objectForKey:FLICKR_PLACE_NAME];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.topPlace objectForKey:FLICKR_LATITUDE]doubleValue];
    coordinate.longitude = [[self.topPlace objectForKey:FLICKR_LONGITUDE]doubleValue];
    return coordinate;
}

@end

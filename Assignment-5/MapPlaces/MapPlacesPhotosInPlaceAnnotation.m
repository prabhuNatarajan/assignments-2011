//
//  MapPlacesPhotosInPlaceAnnotation.m
//  MapPlaces
//
//  Created by Apple on 04/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "MapPlacesPhotosInPlaceAnnotation.h"
#import "FlickrFetcher.h"

@implementation MapPlacesPhotosInPlaceAnnotation

+ (MapPlacesPhotosInPlaceAnnotation *)annotationForPhoto:(NSDictionary *)photo
{
    MapPlacesPhotosInPlaceAnnotation *annotation = [[MapPlacesPhotosInPlaceAnnotation alloc]init];
    annotation.photo = photo;
    return annotation;
}

- (NSString *)title
{
    return [self.photo objectForKey:FLICKR_PHOTO_TITLE];
}

- (NSString *)subtitle
{
    return [self.photo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[self.photo objectForKey:FLICKR_LATITUDE]doubleValue];
    coordinate.longitude = [[self.photo objectForKey:FLICKR_LONGITUDE]doubleValue];
    return coordinate;
}

@end


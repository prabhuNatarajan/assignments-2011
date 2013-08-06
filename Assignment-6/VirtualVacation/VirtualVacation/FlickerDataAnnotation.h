//
//  FlickerDataAnnotation.h
//  VirtualVacation
//
//  Created by Apple on 13/06/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FlickrDataAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSDictionary *data;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property BOOL usePinPadding;
@property BOOL useAnnotationThumbnail;

// factory method for creating annotations using photo, title and subtitle data
+ (FlickrDataAnnotation *)annotationForData:(NSDictionary *)data usingTitle:(NSString *)title andSubtitle:(NSString *)subtitle usingPinPadding:(BOOL)usePadding usingThumbnail:(BOOL)useThumbnail;

@end

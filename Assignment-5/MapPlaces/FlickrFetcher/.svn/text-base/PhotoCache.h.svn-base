//
//  PhotoCache.h
//  MapPlaces
//
//  Created by Apple on 23/05/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoCache : NSObject

- (void)retrievePhotoCache;
- (BOOL)isInCache:(NSDictionary *)photo;
- (NSString *)readImageFromCache:(NSDictionary *)photo;
- (void)writeImageToCache:(UIImage *)image forPhoto:(NSDictionary *)photo fromUrl:(NSURL *)url;

@end

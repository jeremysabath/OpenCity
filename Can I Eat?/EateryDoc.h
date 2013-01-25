//
//  EateryDoc.h
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class EateryData;

@interface EateryDoc : NSObject

@property (strong) EateryData *data;
@property (strong) UIImage *thumbImage;
@property (strong) UIImage *fullImage;


-(id)initWithTitle:(NSString *)title foodtype:(NSString *)foodtype rating:(int) rating description:(NSString *)description opensAt:(float) opensAt closesAt:(float) closesAt isItOpen:(BOOL) isItOpen address:(NSString *)address number:(NSString*) number website:(NSString*) website thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude distance:(float)distance;

@end

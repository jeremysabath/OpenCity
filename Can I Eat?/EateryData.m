//
//  EateryData.m
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import "EateryData.h"

@implementation EateryData

@synthesize title = _title;
@synthesize rating = _rating;
@synthesize foodType = _foodType;
@synthesize description = _description;
@synthesize isItOpen = _isItOpen;

-(id)initWithTitle:(NSString*)title foodtype:(NSString*)footype rating:(int) rating description:(NSString *)description opensAt:(float) opensAt closesAt:(float) closesAt isItOpen:(BOOL)isItOpen address:(NSString *)address number:(NSString*) number website:(NSString*) website latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    if ((self = [super init])) {
        self.title = title;
        self.foodType = footype;
        self.rating = rating;
        self.description = description;
        self.opensAt = opensAt;
        self.closesAt = closesAt;
        self.isItOpen = isItOpen;
        self.address = address;
        self.number = number;
        self.website = website;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}

@end

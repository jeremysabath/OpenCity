//
//  EateryDoc.m
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import "EateryDoc.h"
#import "EateryData.h"

@implementation EateryDoc

@synthesize data = _data;
@synthesize thumbImage = _thumbImage;
@synthesize fullImage = _fullImage;

-(id)initWithTitle:(NSString *)title foodtype:(NSString *)foodtype rating:(int) rating description:(NSString *)description opensAt:(float) opensAt closesAt:(float) closesAt isItOpen:(BOOL) isItOpen address:(NSString *)address number:(NSString*) number website:(NSString*) website thumbImage:(UIImage *)thumbImage fullImage:(UIImage *)fullImage {
    if ((self = [super init])) {
        self.data = [[EateryData alloc] initWithTitle:title foodtype:foodtype rating:rating description:description opensAt:opensAt closesAt:closesAt isItOpen:isItOpen address:address number:number website:website];
        self.thumbImage = thumbImage;
        self.fullImage = fullImage;
    }
    return self;
}

@end

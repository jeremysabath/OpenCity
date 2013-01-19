//
//  EateryData.h
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EateryData : NSObject

@property (strong) NSString *title;
@property (strong) NSString *foodType;
@property (assign) int rating;
@property (strong) NSString *description;
@property float opensAt;
@property float closesAt;
@property (strong) NSString *address;
@property (strong) NSString *number;
@property (strong) NSString *website;
@property (assign) BOOL *isItOpen;

-(id)initWithTitle:(NSString*)title foodtype:(NSString*)footype rating:(int) rating description:(NSString*)description opensAt:(float) opensAt closesAt:(float) closesAt isItOpen:(BOOL)isItOpen address:(NSString*) address number:(NSString*) number website:(NSString*) website;
@end

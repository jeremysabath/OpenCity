//
//  AppDelegate.h
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import <UIKit/UIKit.h>
// Stackmob
#import <CoreData/CoreData.h>

// Stackmob
@class SMClient;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Stackmob
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) SMClient *client;

@end

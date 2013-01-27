//
//  NearbyViewController.h
//  WhereTo
//
//  Created by Jeremy Sabath on 1/23/13.
//  Copyright (c) 2013 Jeremy Sabath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import "MyCLController.h"

@interface NearbyViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate, MyCLControllerDelegate>{
    
    UIBarButtonItem *pickForMeButton;
    CLLocation *currentLocation;
    MyCLController *locationController;
}

@property (strong) CLLocation *currentLocation;
@property (strong, nonatomic) UIWindow *window;
@property (strong) NSMutableArray *eateries;
@property (nonatomic) Class AppDelegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)pickForMeClicked:(id)sender;

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end

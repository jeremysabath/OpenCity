//
//  MasterViewController.h
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//


/*************************************************
 Paul,
 I'm not sure where you're going to start reading through this code, but I thought I'd put this little note here.
 I took the phrase "thoroughly commented" to heart and I hope that you don't find my comments in the middle of if
 statements and whatnot to be too distracting. Also as I told you in person, I used internet sources in helping me 
 figure out objective-C and little iPhone programming tricks along the way. I acknowledge this and give them credit 
 below. In other news, I worked really hard on WhereTo? and I'm really proud of the way it turned out. Thank you for 
 helping me throughout the semester when I was really struggling, and thank you for not throwing my idea to make an 
 iPhone app back in my face when I brought it up for the first time. This final project is one of the most rewarding
 endeavors I've ever set out on. If I don't get to see you, good luck with life after college. You're a badass 
 coding machine and I'm sure you're gonna do great.
 Thanks again for everything,
 Jeremy Sabath
 *************************************************/

/**************************************************
 Sources:
 Making a simple Table View App Tutorial - http://www.raywenderlich.com/1797/how-to-create-a-simple-iphone-app-tutorial-part-1
 Splash Screen Tutorial - http://www.youtube.com/watch?v=pQwFLaAv5Zs&feature=g-hist
 Hide Keyboard Tutorial - http://www.youtube.com/watch?v=MS9bGpmz_0g&feature=g-hist
 Set Background Image Tutorial - http://www.youtube.com/watch?v=k7Ck8nxYnNE&feature=g-hist
 Alert View Tutorial - http://www.youtube.com/watch?v=Kx3FP8szO84&feature=g-hist
 Link to Maps Tutorial - http://www.youtube.com/watch?v=l4jJ5Cs3JHs&feature=g-hist
 Date Formatting Tutorial - http://www.youtube.com/watch?v=usitwq9619w&feature=g-hist
 Search Bar Tutorial - http://www.youtube.com/watch?v=IqDZHgI_s24&feature=g-hist
 Objective C Programming Tutorials Series - http://www.youtube.com/course?list=EC640F44F1C97BA581
 iPhone Development Tutorials Series - http://www.youtube.com/course?list=EC53038489615793F7
  Many wonderful forum posts at http://stackoverflow.com/
 *************************************************/

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import "MyCLController.h"

// Stackmob
#import <CoreData/CoreData.h>

// Stackmob (ONLY "NSFetchedResultsControllerDelegate")
@interface MasterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MFMailComposeViewControllerDelegate, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate, MyCLControllerDelegate>{
    
    // delcare bar button's pick for me and contact us
    UIBarButtonItem *pickForMeButton;
    UIBarButtonItem *contactUsButton;
    
    CLLocation *currentLocation;
    MyCLController *locationController;
}

@property (strong) CLLocation *currentLocation;

// Stackmob
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

// connect search bar to code
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

// generate tableView
@property (strong, nonatomic) IBOutlet UITableView *tableView;



@property (strong, nonatomic) UIWindow *window;
@property (strong) NSMutableArray *eateries;
@property (nonatomic) Class AppDelegate;
@property (weak, nonatomic) UIActionSheet *actionSheet;

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

// Open Now button
- (IBAction)openNowClicked:(id)sender;
- (IBAction)sortByClicked:(id)sender;


// methods for user clicking buttons
- (IBAction)pickForMeClicked:(id)sender;
- (IBAction)contactUsClicked:(id)sender;

// Stackmob
- (IBAction)createNewObject:(id)sender;

@end

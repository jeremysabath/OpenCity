//
//  MasterViewController.m
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import "MasterViewController.h"
#import <MessageUI/MessageUI.h>
#import "DetailViewController.h"
#import "EateryData.h"
#import "EateryDoc.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

// Stackmob
#import "StackMob.h"

@interface MasterViewController () <UIActionSheetDelegate> {
    NSMutableArray *_objects;
    
    // create array of all eateries, just search results and bool for if search text was entered
    NSMutableArray *allItems;
    NSMutableArray *searchResults;
    NSMutableArray *currentEateryArray;
    NSMutableArray *tempArray;
    bool sortedByDistance;
    bool sortedFirst;
    bool sortedIsCorrect;
    bool whatsOpen;
    bool searchTextEntered;
    bool ready;
    int cellCounter;
    int counter;
    }
@end


@implementation MasterViewController{
}

// Stackmob
@synthesize managedObjectContext = _managedObjectContext;

// synthesize properties
@synthesize eateries = _eateries;
@synthesize window;
@synthesize AppDelegate;
@synthesize tableView;
@synthesize actionSheet = _actionSheet;

// Stackmob
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)nothingOpenApology {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Sorry!"
                          message:@"Everything's closed right now, try again later!"
                          delegate:self
                          cancelButtonTitle:@"Done"
                          otherButtonTitles: nil];
    [alert show];
    currentEateryArray = [[NSMutableArray alloc]initWithArray:tempArray];
}

- (void)sortByDistance: (NSMutableArray *)array {
    sortedByDistance = YES;
    int eateryCount = [array count];
    double lastDistance;
    id distanceID;
    id orderID;
    CLLocation *eateryLocation;
    NSMutableArray *distancesArray = [[NSMutableArray alloc]init];
    NSMutableDictionary *distancesDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < eateryCount; i++){
        EateryDoc *localEatery = [[EateryDoc alloc]init];
        localEatery = array[i];
        do {
            eateryLocation = [[CLLocation alloc] initWithLatitude:localEatery.data.latitude longitude:localEatery.data.longitude];
        }
        while (!eateryLocation);
        CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
        double mileConversion = distance * 0.000621371192;
        orderID = [NSNumber numberWithInt:i];
        for (int j = 0; j < [distancesArray count]; j++) {
            while (mileConversion == [distancesArray[j] doubleValue]) {
                mileConversion = [distancesArray[j] doubleValue] + 0.001;
            }
        }
        distanceID = [NSNumber numberWithDouble:mileConversion];
        [distancesDict setValue:orderID forKey:distanceID];
        [distancesArray addObject:[NSNumber numberWithDouble:mileConversion]];
    }
    NSMutableArray *sortedKeys = [[NSMutableArray alloc]init];
    sortedKeys = [[distancesDict allKeys]sortedArrayUsingSelector:@selector(compare:)];
    int dictCount = [distancesDict count];
    for (int i = 0; i < dictCount; i++) {
        int key = [[distancesDict objectForKey:sortedKeys[i]] integerValue];
        EateryDoc *sortedEatery = array[key];
        if (searchTextEntered == NO){
            [currentEateryArray addObject:sortedEatery];
        }
        else {
            [searchResults addObject:sortedEatery];
        }
    }
    NSLog(@"Total Eateries = %u", [currentEateryArray count]);
}

- (void)sortByFirstLetter: (NSMutableArray *)array {
    sortedByDistance = NO;
    int eateryCount = [array count];
    NSMutableDictionary *titlesDict = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < eateryCount; i++) {
        EateryDoc *eatery = [[EateryDoc alloc]init];
        eatery = array[i];
        id orderID = [NSNumber numberWithInt:i];
        id titleID = eatery.data.title;
        [titlesDict setValue:orderID forKey:titleID];
    }
    NSMutableArray *sortedKeys = [[NSMutableArray alloc]init];
    sortedKeys = [[titlesDict allKeys]sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    int dictCount = [titlesDict count];
    for (int i = 0; i < dictCount; i++) {
        int key = [[titlesDict objectForKey:sortedKeys[i]] integerValue];
        EateryDoc *sortedEatery = array[key];
        if (searchTextEntered == NO){
            [currentEateryArray addObject:sortedEatery];
        }
        else {
            [searchResults addObject:sortedEatery];
        }
    }
}

- (void)sortWhatsOpen: (NSMutableArray *)array {
    int eateryCount = [array count];
    for (int i = 0; i < eateryCount; i++) {
        resultEatery = [array objectAtIndex:i];
        NSString *open;
        if (resultEatery.data.isItOpen == YES){
            open = @"open";
        }
        else {
            open = nil;
        }
        NSString *allData = [NSString stringWithFormat:@"%@", open];
        NSRange stringRange = [allData rangeOfString:@"open" options:NSCaseInsensitiveSearch];
        if (stringRange.location != NSNotFound){
            [currentEateryArray addObject:resultEatery];
        }
    }
}

- (void)sortShowAll: (NSMutableArray *)array {
    if (searchTextEntered == NO){
        tempArray = [[NSMutableArray alloc]initWithArray:allItems];
    }
    else {
        tempArray = [[NSMutableArray alloc]initWithArray:searchResults];
        [searchResults removeAllObjects];
    }
    [currentEateryArray removeAllObjects];
    // sorted by Distance
    if (sortedByDistance == YES){
        [self sortByDistance:tempArray];
    }
    // sorted by First Letter
    else {
        [self sortByFirstLetter:tempArray];
    }
}

- (void)whatsOpenAlert {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"OpenNow"
                          message:@"Here's WhatsOpen!"
                          delegate:self
                          cancelButtonTitle:@"Done"
                          otherButtonTitles: nil];
    [alert show];
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1];
    self.navigationItem.leftBarButtonItem.title = @"ShowAll";
}

- (void)showAllAlert {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"ShowAll"
                          message:@"Here's everything!"
                          delegate:self
                          cancelButtonTitle:@"Done"
                          otherButtonTitles: nil];
    [alert show];
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1];
    self.navigationItem.leftBarButtonItem.title = @"WhatsOpen";

}

- (void)dismissAlert: (UIAlertView *)alert {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// loadLocations
/*
- (void)loadLocations {
    int eateryCount = [allItems count];
    double lastDistance;
    CLLocation *eateryLocation;
    // currently showing all
    if(clicked == NO){
        [distancesDict removeAllObjects];
        for (int i = 0; i < eateryCount; i++){
            localEatery = allItems[i];
            do {
                eateryLocation = [[CLLocation alloc] initWithLatitude:localEatery.data.latitude longitude:localEatery.data.longitude];
            }
            while (!eateryLocation);
                CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                while (distance == lastDistance){
                    distance = lastDistance+.001;
                double mileConversion = distance * 0.000621371192;
                id orderID = [NSNumber numberWithInt:i];
                id distanceID = [NSNumber numberWithDouble:mileConversion];
                [distancesDict setValue:orderID forKey:distanceID];
                lastDistance = distance;
            }
        }
        NSMutableArray *sortedKeys = [[NSMutableArray alloc]init];
        sortedKeys = [[distancesDict allKeys]sortedArrayUsingSelector:@selector(compare:)];
        int dictCount = [distancesDict count];
        for (int i = 0; i < dictCount; i++) {
            if (dictCount == 0 || dictCount == 1){
                break;
            }
            else {
                int key = [[distancesDict objectForKey:sortedKeys[i]] integerValue];
                EateryDoc *sortedEatery = allItems[key];
                [sortedEateries addObject:sortedEatery];
            }
        }
        if ([sortedEateries count] == 0){
            sortedEateries = allItems;
        }
    }
    // currently showing what's open
    else {
        eateryCount = [sortedEateries count];
        for (int i = 0; i < eateryCount; i++){
            localEatery = searchResults[i];
            do {
                eateryLocation = [[CLLocation alloc] initWithLatitude:localEatery.data.latitude longitude:localEatery.data.longitude];
            }
            while (!eateryLocation);
            CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
            while (distance == lastDistance){
                distance = lastDistance+.001;
            }
            double mileConversion = distance * 0.000621371192;
            id orderID = [NSNumber numberWithInt:i];
            id distanceID = [NSNumber numberWithDouble:mileConversion];
            [distancesDict setValue:orderID forKey:distanceID];
            }
        NSMutableArray *sortedKeys = [[NSMutableArray alloc]init];
        sortedKeys = [[distancesDict allKeys]sortedArrayUsingSelector:@selector(compare:)];
        int dictCount = [distancesDict count];
        for (int i = 0; i < dictCount; i++) {
            if (dictCount == 0 || dictCount == 1){
                break;
            }
            else {
                int key = [[distancesDict objectForKey:sortedKeys[i]] integerValue];
                EateryDoc *sortedEatery = allItems[key];
                [sortedEateries addObject:sortedEatery];
            }
        }
        if ([sortedEateries count] == 0){
            sortedEateries = searchResults;
        }
    }
currentEateryArray = sortedEateries;
}
*/

- (void)viewDidAppear:(BOOL)animated {
    currentEateryArray = [[NSMutableArray alloc]initWithArray:self.eateries];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    sleep(1.5);
    [super viewDidLoad];
    allItems = [[NSMutableArray alloc]initWithArray:self.eateries];
    [self sortByFirstLetter:allItems];
    searchResults = [[NSMutableArray alloc]initWithArray:allItems];
    currentEateryArray = [[NSMutableArray alloc]initWithArray:allItems];
    tempArray = [[NSMutableArray alloc]init];
    
    whatsOpen = YES;

    locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
    
    // give view title, initialize 
    self.title = @"WhereTo?";
    //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    // Stackmob
    self.managedObjectContext = [self.appDelegate managedObjectContext];
    
    [self.tableView reloadData];
}

- (void)locationUpdate:(CLLocation *)location {
	self.currentLocation = location;
    NSLog(@"%@", self.currentLocation);
}

- (void)locationError:(NSError *)error {
    NSString *errorMessage = [error description];
	NSLog(@"Error: %@", errorMessage);
}

#pragma  mark - Search Bar

@synthesize searchBar= searchBar;

// Apple Housekeeping
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Apple Housekeeping
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

// Search Bar implementation
EateryDoc *resultEatery;
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    tempArray = [[NSMutableArray alloc]initWithArray:currentEateryArray];
    [searchResults removeAllObjects];
    
    if (searchText.length == 0) {
        searchTextEntered = NO;
        if ([tempArray count] != 0) {
            currentEateryArray = [[NSMutableArray alloc]initWithArray:tempArray];
        }
        else {
            currentEateryArray = [[NSMutableArray alloc]initWithArray:allItems];
        }
        [self.tableView reloadData];
        [self.searchBar resignFirstResponder];
    }
    
    else {
        searchTextEntered = YES;
        int eateryCount = [tempArray count];
        // checks each eatery, one by one, for search criteria, adds matches to array searchResults
        for (int i = 0; i < eateryCount; i++) {
            resultEatery = [tempArray objectAtIndex:i];
            NSString *title = resultEatery.data.title;
            NSString *foodtype = resultEatery.data.foodType;
            NSString *description = resultEatery.data.description;
            NSString *open;
            
            if (resultEatery.data.isItOpen == NO){
                open = nil;
            }
            else {
                open = @"open";
            }
            NSString *allData = [NSString stringWithFormat:@"%@ %@ %@ %@", title, foodtype, description, open];
            NSRange stringRange = [allData rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (stringRange.location != NSNotFound){
                [searchResults addObject:resultEatery];
            }
        }
    }
    [self.tableView reloadData];
}

/*
-(void)reloadForLocation {
    int eateryCount = [allItems count];
    for (int i = 0; i < eateryCount; i++) {
        resultEatery = [allItems objectAtIndex:i];
        [searchResults addObject:resultEatery];
    }
    [self.tableView reloadData];
}
*/

// hides keyboard when search button clicked
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    // hide keyboard
    [self.searchBar resignFirstResponder];
}

// hides keyboard when user scrolls
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (IBAction)openNowClicked:(id)sender{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if (searchTextEntered == NO){
        array = [[NSMutableArray alloc]initWithArray:currentEateryArray];
    }
    else {
        array = [[NSMutableArray alloc]initWithArray:searchResults];
    }
    [currentEateryArray removeAllObjects];
    
    // whatsOpen clicked
    if (whatsOpen == YES){
        [self sortWhatsOpen:array];
        // if nothing is open
        if ([currentEateryArray count] == 0){
            [self nothingOpenApology]; // sets currenteateryarray to temp
            whatsOpen = YES;
        }
        else {
            [self whatsOpenAlert];
            whatsOpen = NO;
        }
    }
    
    // showAll clicked
    else {
        [self sortShowAll:tempArray];
        whatsOpen = YES;
        [self showAllAlert];
    }
    [self.tableView reloadData];
    
    /*
    if (distanceSorted == NO){
        // currently showing all
        if (clicked == NO){
            clicked = YES;
            int eateryCount = [allItems count];
            searchResults = [[NSMutableArray alloc]init];
            // checks each eatery, one by one, for search criteria, adds matches to array searchResults
            for (int i = 0; i < eateryCount; i++) {
                resultEatery = [allItems objectAtIndex:i];
                NSString *open;
                if (resultEatery.data.isItOpen == NO){
                    open = @"closed";
                }
                else {
                    open = @"open";
                }
                NSString *allData = [NSString stringWithFormat:@"%@", open];
                NSRange stringRange = [allData rangeOfString:@"open" options:NSCaseInsensitiveSearch];
                if (stringRange.location != NSNotFound){
                    [searchResults addObject:resultEatery];
                }
            }
            if ([searchResults count] == 0){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry!"
                                      message:@"Nothing's open, try again later!"
                                      delegate:self
                                      cancelButtonTitle:@"Done"
                                      otherButtonTitles: nil];
                [alert show];
                clicked = NO;
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"OpenNow"
                                  message:@"Here's WhatsOpen!"
                                  delegate:self
                                  cancelButtonTitle:@"Cool"
                                  otherButtonTitles: nil];
            [alert show];
            self.navigationItem.leftBarButtonItem.title = @"ShowAll";
            }
        }
        else{
            clicked = NO;
            int eateryCount = [allItems count];
            searchResults = [[NSMutableArray alloc]init];
            // checks each eatery, one by one, for search criteria, adds matches to array searchResults
            for (int i = 0; i < eateryCount; i++) {
                searchTextEntered = NO;
                resultEatery = [allItems objectAtIndex:i];
                [searchResults addObject:resultEatery];
            }
            if ([searchResults count] == 0){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry!"
                                      message:@"Nothing's open, try again later!"
                                      delegate:self
                                      cancelButtonTitle:@"Done"
                                      otherButtonTitles: nil];
                [alert show];
                clicked = NO;
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"ShowAll"
                                      message:@"Here's everything!!"
                                      delegate:self
                                      cancelButtonTitle:@"Cool"
                                      otherButtonTitles: nil];
                [alert show];
                self.navigationItem.leftBarButtonItem.title = @"WhatsOpen";
            }
        }
    }
    // if distance sorted
    else {
        // if all are showing
        if (clicked == NO){
            clicked = YES;
            int eateryCount = [sortedEateries count];
            searchResults = [[NSMutableArray alloc]init];
            // checks each eatery, one by one, for search criteria, adds matches to array searchResults
            for (int i = 0; i < eateryCount; i++) {
                searchTextEntered = YES;
                resultEatery = [sortedEateries objectAtIndex:i];
                NSString *open;
                
                if (resultEatery.data.isItOpen == NO){
                    open = @"closed";
                }
                else {
                    open = @"open";
                }
                NSString *allData = [NSString stringWithFormat:@"%@", open];
                NSRange stringRange = [allData rangeOfString:@"open" options:NSCaseInsensitiveSearch];
                if (stringRange.location != NSNotFound){
                    [searchResults addObject:resultEatery];
                }
            }
            if ([searchResults count] == 0){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry!"
                                      message:@"Nothing's open, try again later!"
                                      delegate:self
                                      cancelButtonTitle:@"Done"
                                      otherButtonTitles: nil];
                [alert show];
                clicked = NO;
                sortedFirst = YES;
                sortedIsCorrect = YES;
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"OpenNow"
                                      message:@"Here's WhatsOpen!"
                                      delegate:self
                                      cancelButtonTitle:@"Cool"
                                      otherButtonTitles: nil];
                [alert show];
                self.navigationItem.leftBarButtonItem.title = @"ShowAll";
            }            
        }
        // if only open are showing
        else{
            clicked = NO;
            int eateryCount = [sortedEateries count];
            searchResults = [[NSMutableArray alloc]init];
            // checks each eatery, one by one, for search criteria, adds matches to array searchResults
            for (int i = 0; i < eateryCount; i++) {
                searchTextEntered = YES;
                resultEatery = [sortedEateries objectAtIndex:i];
                [searchResults addObject:resultEatery];
            }
            if ([searchResults count] == 0){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry!"
                                      message:@"Nothing's open, try again later!"
                                      delegate:self
                                      cancelButtonTitle:@"Done"
                                      otherButtonTitles: nil];
                [alert show];
                clicked = NO;
                sortedFirst = YES;
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"ShowAll"
                                      message:@"Here's everything!"
                                      delegate:self
                                      cancelButtonTitle:@"Cool"
                                      otherButtonTitles: nil];
                [alert show];
                self.navigationItem.leftBarButtonItem.title = @"WhatsOpen";
            }
            
        }
        if (sortedIsCorrect == NO){
            sortedEateries = searchResults;
        }
    }
     */
}

- (IBAction)sortByClicked:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"SortedBy FirstLetter", @"SortedBy Distance", nil];
    [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (searchTextEntered == NO){
        tempArray = [[NSMutableArray alloc]initWithArray:currentEateryArray];
        [currentEateryArray removeAllObjects];
    }
    else {
        tempArray = [[NSMutableArray alloc]initWithArray:searchResults];
        [searchResults removeAllObjects];
    }
    // SortBy FirstLetter Clicked
    if (buttonIndex == 0)
    {
        [self sortByFirstLetter:tempArray];
        [self.tableView reloadData];
    }
    // SortBy Distance Clicked
    else if (buttonIndex == 1){
        [self sortByDistance:tempArray];
        // myTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(callAfterTwoSeconds:) userInfo: nil repeats: YES];
        [self.tableView reloadData];
    }
}
#pragma mark - Table View

// Table has one section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// table has number of rows equal to number of eateries...
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (searchTextEntered == NO){
        return [currentEateryArray count];  
    }
    else {
        return [searchResults count];
    }
    
    /*
    else if (sortedFirst == YES){
        sortedFirst = NO;
        return [sortedEateries count];
    }
    else {
        // will be alphabetical
        if (distanceSorted == NO){
            // currently showing all
            if (clicked == NO) {
                if (searchTextEntered == YES){
                    return [searchResults count];
                }
                // ... in total
                else {
                    return [allItems count];
                }
            }
            // currently showing whatsopen
            else {
                // ... in searchResults
                if (searchTextEntered == YES){
                    return [searchResults count];
                }
                // ... in total
                else {
                    return [searchResults count];
                }
            }
        }
        // will be sorted
        else {
            // showing all
            if (clicked == NO) {
                if (searchTextEntered == YES){
                    return [sortedEateries count];
                }
                // ... in total
                else {
                    return [sortedEateries count];
                }
            }
            else {
                if (searchTextEntered == YES){
                    return [sortedEateries count];
                }
                // ... in total
                else {
                    return [sortedEateries count];
                }
            }
        }
    }
     */
}

/**********
// Stackmob
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
************/

 // builds cells one by one with correct information
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchTextEntered == NO){
        cellCounter = [currentEateryArray count];
    }
    else {
        cellCounter = [searchResults count];
    }
    // Get current time
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH.mm.ss"];
    NSString *stringTime = [formatter stringFromDate:[NSDate date]];
    float time = [stringTime floatValue];
    
    // Declare cell properties
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyBasicCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MyBasicCell"];
    }
    self.tableView.rowHeight = 61;
    cell.detailTextLabel.font = [UIFont fontWithName:@"American Typewriter" size:16];
    cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:20];
    cell.textLabel.textColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1];
    cell.textLabel.shadowColor = [UIColor blackColor];
    cell.textLabel.shadowOffset = CGSizeMake(0,-1);
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    
    // Get Eatery data
    CLLocation *eateryLocation;
    EateryDoc *eatery = [[EateryDoc alloc]init];
    if (searchTextEntered == NO){
        eatery = [currentEateryArray objectAtIndex:indexPath.row];
    }
    else {
        eatery = [searchResults objectAtIndex:indexPath.row];
    }
    if([eatery.data.title length] > 14){
        NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
        cell.textLabel.text = titleText;
    }
    else{
        cell.textLabel.text = eatery.data.title;
    }
    cell.imageView.image = eatery.thumbImage;
    do {
        eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
    }
    while (!eateryLocation);
    
    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
    double mileConversion = distance * 0.000621371192;
    NSString *distanceString = [NSString stringWithFormat:@"%.2f mi", mileConversion];
    if (eatery.data.isItOpen == YES){
        if ((eatery.data.closesAt - time) <= 0.70 && (eatery.data.closesAt - time) > 0) {
            cell.detailTextLabel.textColor = [UIColor yellowColor];
        }
        else {
            cell.detailTextLabel.textColor = [UIColor greenColor];
        }
    }
    else {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    cell.detailTextLabel.text = distanceString;
    return cell;
    // if alphabetical...
    /*
    if (distanceSorted == NO) {
        // ...and will show all
        if (clicked == NO) {
            // if unsearched
            if (searchTextEntered == NO) {
                self.tableView.rowHeight = 61;
                eatery = [allItems objectAtIndex:indexPath.row];
                if([eatery.data.title length] > 14){
                    NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
                    cell.textLabel.text = titleText;
                }
                else{
                    cell.textLabel.text = eatery.data.title;
                }
                cell.imageView.image = eatery.thumbImage;
                CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
                if(eateryLocation){
                    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                    double mileConversion = distance * 0.000621371192;
                    //NSNumber *distanceID = [NSNumber numberWithDouble:mileConversion];
                    //NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    //formatter.maximumFractionDigits = 1;
                    //NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
                    NSString *distanceString = [NSString stringWithFormat:@"%.2f mi", mileConversion];
                    if (eatery.data.isItOpen == YES){
                        cell.detailTextLabel.textColor = [UIColor greenColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    else {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    
                }
            }
            else {
                self.tableView.rowHeight = 61;
                eatery = [searchResults objectAtIndex:indexPath.row];
                if([eatery.data.title length] > 14){
                    NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
                    cell.textLabel.text = titleText;
                }
                else{
                    cell.textLabel.text = eatery.data.title;
                }
                cell.imageView.image = eatery.thumbImage;
                CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
                if(eateryLocation){
                    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                    double mileConversion = distance * 0.000621371192;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.maximumFractionDigits = 1;
                    NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
                    NSString *distanceString = [NSString stringWithFormat:@"%@ mi", [distanceFromEatery stringValue]];
                    if (eatery.data.isItOpen == YES){
                        cell.detailTextLabel.textColor = [UIColor greenColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    else {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                }
            }
        }
        // and will show whatsopen
        else {
            // if unsearched
            if (searchTextEntered == NO) {
                self.tableView.rowHeight = 61;
                eatery = [searchResults objectAtIndex:indexPath.row];
                if([eatery.data.title length] > 14){
                    NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
                    cell.textLabel.text = titleText;
                }
                else{
                    cell.textLabel.text = eatery.data.title;
                }
                cell.imageView.image = eatery.thumbImage;
                CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
                if(eateryLocation){
                    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                    double mileConversion = distance * 0.000621371192;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.maximumFractionDigits = 1;
                    NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
                    NSString *distanceString = [NSString stringWithFormat:@"%@ mi", [distanceFromEatery stringValue]];
                    if (eatery.data.isItOpen == YES){
                        cell.detailTextLabel.textColor = [UIColor greenColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    else {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    
                }
            }
            else {
                self.tableView.rowHeight = 61;
                eatery = [searchResults objectAtIndex:indexPath.row];
                if([eatery.data.title length] > 14){
                    NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
                    cell.textLabel.text = titleText;
                }
                else{
                    cell.textLabel.text = eatery.data.title;
                }
                cell.imageView.image = eatery.thumbImage;
                CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
                if(eateryLocation){
                    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                    double mileConversion = distance * 0.000621371192;
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.maximumFractionDigits = 1;
                    NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
                    NSString *distanceString = [NSString stringWithFormat:@"%@ mi", [distanceFromEatery stringValue]];
                    if (eatery.data.isItOpen == YES){
                        cell.detailTextLabel.textColor = [UIColor greenColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    else {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                }
            }
        }
    }
    // if distance sorted
    else {
        if (clicked == NO) {
            if (searchTextEntered == NO) {
                self.tableView.rowHeight = 61;
                eatery = [sortedEateries objectAtIndex:indexPath.row];
                if([eatery.data.title length] > 14){
                    NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
                    cell.textLabel.text = titleText;
                }
                else{
                    cell.textLabel.text = eatery.data.title;
                }
                cell.imageView.image = eatery.thumbImage;
                CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
                if(eateryLocation){
                    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                    double mileConversion = distance * 0.000621371192;
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.maximumFractionDigits = 1;
                    NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
                    NSString *distanceString = [NSString stringWithFormat:@"%@ mi", [distanceFromEatery stringValue]];
                    if (eatery.data.isItOpen == YES){
                        cell.detailTextLabel.textColor = [UIColor greenColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    else {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                }
            }
            else {
                self.tableView.rowHeight = 61;
                eatery = [sortedEateries objectAtIndex:indexPath.row];
                if([eatery.data.title length] > 14){
                    NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
                    cell.textLabel.text = titleText;
                }
                else{
                    cell.textLabel.text = eatery.data.title;
                }            cell.imageView.image = eatery.thumbImage;
                CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
                if(eateryLocation){
                    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                    double mileConversion = distance * 0.000621371192;
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.maximumFractionDigits = 1;
                    NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
                    NSString *distanceString = [NSString stringWithFormat:@"%@ mi", [distanceFromEatery stringValue]];
                    if (eatery.data.isItOpen == YES){
                        cell.detailTextLabel.textColor = [UIColor greenColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    else {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                }
            }
        }
        else {
            if (searchTextEntered == NO) {
                self.tableView.rowHeight = 61;
                eatery = [sortedEateries objectAtIndex:indexPath.row];
                if([eatery.data.title length] > 14){
                    NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
                    cell.textLabel.text = titleText;
                }
                else{
                    cell.textLabel.text = eatery.data.title;
                }
                cell.imageView.image = eatery.thumbImage;
                CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
                if(eateryLocation){
                    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                    double mileConversion = distance * 0.000621371192;
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.maximumFractionDigits = 1;
                    NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
                    NSString *distanceString = [NSString stringWithFormat:@"%@ mi", [distanceFromEatery stringValue]];
                    if (eatery.data.isItOpen == YES){
                        cell.detailTextLabel.textColor = [UIColor greenColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    else {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                }
            }
            else {
                self.tableView.rowHeight = 61;
                eatery = [sortedEateries objectAtIndex:indexPath.row];
                if([eatery.data.title length] > 14){
                    NSString *titleText = [NSString stringWithFormat:@"%@...", [eatery.data.title substringToIndex:14]];
                    cell.textLabel.text = titleText;
                }
                else{
                    cell.textLabel.text = eatery.data.title;
                }            cell.imageView.image = eatery.thumbImage;
                CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
                if(eateryLocation){
                    CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                    double mileConversion = distance * 0.000621371192;
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.maximumFractionDigits = 1;
                    NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
                    NSString *distanceString = [NSString stringWithFormat:@"%@ mi", [distanceFromEatery stringValue]];
                    if (eatery.data.isItOpen == YES){
                        cell.detailTextLabel.textColor = [UIColor greenColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                    else {
                        cell.detailTextLabel.textColor = [UIColor redColor];
                        cell.detailTextLabel.text = distanceString;
                    }
                }
            }
        }
    }
     */
    // set's background image of table
       // self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
        // NSLog(@"tableview: %@", [self.eateries objectAtIndex:indexPath.row]);
}

/*********
// Stackmob
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyBasicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [object valueForKey:@"title"];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    NSLog(@"fetchedResultsController = %@", _fetchedResultsController);

    return cell;
}

// Stackmob
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Eatery" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // NSPredicate *equalPredicate =[NSPredicate predicateWithFormat:@"title == %@", @"Al's Cafe"];
    // [fetchRequest setPredicate:equalPredicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    NSLog(@"aFetchedResultsController = %@", aFetchedResultsController);
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"An error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}
**********************************/

// Stackmob
- (IBAction)createNewObject:(id)sender {
    
    int eateryCount = [allItems count];
    for (int i = 0; i < eateryCount; i++) {
        EateryDoc *eatery = allItems[i];
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Eatery" inManagedObjectContext:self.managedObjectContext];
    
        [newManagedObject setValue:eatery.data.title forKey:@"title"];
        //[newManagedObject setValue:eatery.data.rating forKey:@"rating"];
        [newManagedObject setValue:eatery.data.foodType forKey:@"foodtype"];
        [newManagedObject setValue:eatery.data.description forKey:@"descript"];
        //[newManagedObject setValue:eatery.data.opensAt forKey:@"opensAt"];
        //[newManagedObject se forKey:@"closesAt"];
        //[newManagedObject setValue:eatery.data.isItOpen forKey:@"isItOpen"];
        [newManagedObject setValue:eatery.data.address forKey:@"address"];
        [newManagedObject setValue:eatery.data.website forKey:@"website"];

        [newManagedObject setValue:[newManagedObject assignObjectId] forKey:[newManagedObject primaryKeyField]];
    
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"There was an error! %@", error);
        }
        else {
            NSLog(@"You created a new object!");
        }
    }
}

// When a cell or pickforme is clicked, pushes to the detail view corresponding to the correct eatery
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if (searchTextEntered == NO){
        array = [[NSMutableArray alloc]initWithArray:currentEateryArray];
    }
    else {
        array = [[NSMutableArray alloc]initWithArray:searchResults];
    }
    // if pickforme (tag 1000) is clicked, picks a random eatery, checks if it's open and displays the detail view
    if([sender tag] == 1000) {
        EateryDoc *eatery = [[EateryDoc alloc]init];
        // declares a detailViewController
        DetailViewController *detailController;
        int count = 1;
        do {
            int r;
            // picks random integer <= total number of eateries
            r = arc4random() % [array count];
            detailController = segue.destinationViewController;
            // picks random eatery based on random int
            eatery = [array objectAtIndex:r];
            count++;
        }
        while (eatery.data.isItOpen == NO && count <= [array count]);
        // if everything's closed, apologize
        if (count == [array count]){
            [self nothingOpenApology];
        }
        detailController.detailItem = eatery;
    }
    else {
        EateryDoc *eatery = [[EateryDoc alloc]init];
        DetailViewController *detailController = segue.destinationViewController;
        eatery = [array objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        detailController.detailItem = eatery;
    }
    [self.searchBar resignFirstResponder];

    /*
    allItems = [[NSMutableArray alloc]initWithArray:_eateries];
    if (distanceSorted == NO){
        // if pickforme (tag 1000) is clicked, picks a random eatery, checks if it's open and displays the detail view
        if([sender tag] == 1000){
            EateryDoc *eatery;
            // declares a detailViewController
            DetailViewController *detailController;
            int count = 1;
            do {
                int r;
                // picks random integer <= total number of eateries
                r = arc4random() % [searchResults count];
                detailController = segue.destinationViewController;
                // picks random eatery based on random int
                NSLog(@"LOADING EATERY");
                eatery = [searchResults objectAtIndex:r];
                count++;
            }
            // if it's closed pick another, if EVERYTHING is closed alert the user
            while (eatery.data.isItOpen == NO && count <= [_eateries count]);
            // Apologize to user if all is closed
            if (count == [_eateries count]){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry!"
                                      message:@"Everything's closed right now! Try again soon!"
                                      delegate:self
                                      cancelButtonTitle:@"Done"
                                      otherButtonTitles: nil];
                [alert show];
            }
            detailController.detailItem = eatery;
        }
        
        // pick the correct eatery based on the searchResults
        else if (searchTextEntered == YES) {
            DetailViewController *detailController = segue.destinationViewController;
            EateryDoc *eatery = [searchResults objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            detailController.detailItem = eatery;
            [self.searchBar resignFirstResponder];
        }
        // pick the correct eatery simply based on original order
        else{
            NSLog(@"SENDER = %@", sender);
            DetailViewController *detailController = segue.destinationViewController;
            
            EateryDoc *eatery = [self.eateries objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            // EateryDoc *eatery = [_fetchedResultsController.fetchedObjects objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            NSLog(@"eatery = %@", eatery);
            detailController.detailItem = eatery;
            NSLog(@"THE FIRST LETTER IS: %@", [eatery.data.title substringToIndex:1]);
            
            // loadData experiment
            NSLog(@"Al's isItOpen = %i", eatery.data.isItOpen);
            NSLog(@"Al's closesAt = %f", eatery.data.closesAt);
            
            // hides keyboard
            [self.searchBar resignFirstResponder];
        }
    }
    // if distanceSorted
    else {
        // if pickforme (tag 1000) is clicked, picks a random eatery, checks if it's open and displays the detail view
        if([sender tag] == 1000){
            EateryDoc *eatery;
            // declares a detailViewController
            DetailViewController *detailController;
            int count = 1;
            do {
                int r;
                // picks random integer <= total number of eateries
                r = arc4random() % [sortedEateries count];
                detailController = segue.destinationViewController;
                // picks random eatery based on random int
                NSLog(@"LOADING EATERY");
                eatery = [sortedEateries objectAtIndex:r];
                count++;
            }
            // if it's closed pick another, if EVERYTHING is closed alert the user
            while (eatery.data.isItOpen == NO && count <= [sortedEateries count]);
            // Apologize to user if all is closed
            if (count == [sortedEateries count]){
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry!"
                                      message:@"Everything's closed right now! Try again soon!"
                                      delegate:self
                                      cancelButtonTitle:@"Done"
                                      otherButtonTitles: nil];
                [alert show];
            }
            detailController.detailItem = eatery;
        }
        
        // pick the correct eatery based on the searchResults
        else if (searchTextEntered == YES) {
            DetailViewController *detailController = segue.destinationViewController;
            EateryDoc *eatery = [sortedEateries objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            detailController.detailItem = eatery;
            [self.searchBar resignFirstResponder];
        }
        // pick the correct eatery simply based on original order
        else{
            NSLog(@"SENDER = %@", sender);
            DetailViewController *detailController = segue.destinationViewController;
            
            EateryDoc *eatery = [sortedEateries objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            // EateryDoc *eatery = [_fetchedResultsController.fetchedObjects objectAtIndex:self.tableView.indexPathForSelectedRow.row];
            NSLog(@"eatery = %@", eatery);
            detailController.detailItem = eatery;
            NSLog(@"THE FIRST LETTER IS: %@", [eatery.data.title substringToIndex:1]);
            
            // loadData experiment
            NSLog(@"Al's isItOpen = %i", eatery.data.isItOpen);
            NSLog(@"Al's closesAt = %f", eatery.data.closesAt);
            
            // hides keyboard
            [self.searchBar resignFirstResponder];
        }
    }
     */
}
@end

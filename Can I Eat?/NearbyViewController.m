//
//  NearbyViewController.m
//  WhereTo
//
//  Created by Jeremy Sabath on 1/23/13.
//  Copyright (c) 2013 Jeremy Sabath. All rights reserved.
//

#import "NearbyViewController.h"
#import <MessageUI/MessageUI.h>
#import "DetailViewController.h"
#import "EateryData.h"
#import "EateryDoc.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface NearbyViewController () {
    NSMutableArray *_objects;
    
    // create array of all eateries, just search results and bool for if search text was entered
    NSMutableArray *allItems;
    NSMutableArray *searchResults;
    BOOL searchTextEntered;
    NSMutableDictionary *distancesDict;
    NSMutableArray *sortedEateries;
    EateryDoc *localEatery;
    
    NSTimer *myTimer;
}

@end

@implementation NearbyViewController

// synthesize properties
@synthesize eateries = _eateries;
@synthesize searchBar= searchBar;
@synthesize window;
@synthesize AppDelegate;
@synthesize tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadLocations {
    sortedEateries = [[NSMutableArray alloc]init];
    distancesDict = [[NSMutableDictionary alloc]init];
    allItems = [[NSMutableArray alloc]initWithArray:self.eateries];
    int eateryCount = [allItems count];
    if(searchTextEntered == NO){
        for (int i = 0; i < eateryCount; i++){
            localEatery = allItems[i];
            CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:localEatery.data.latitude longitude:localEatery.data.longitude];
            if(eateryLocation){
                CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                double mileConversion = distance * 0.00062137119200000000000001;
                id orderID = [NSNumber numberWithInt:i];
                id distanceID = [NSNumber numberWithDouble:mileConversion];
                [distancesDict setValue:orderID forKey:distanceID];
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
    else {
        eateryCount = [sortedEateries count];
        for (int i = 0; i < eateryCount; i++){
            localEatery = searchResults[i];
            CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:localEatery.data.latitude longitude:localEatery.data.longitude];
            if(eateryLocation){
                CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
                double mileConversion = distance * 0.00062137119200000000000001;
                id orderID = [NSNumber numberWithInt:i];
                id distanceID = [NSNumber numberWithDouble:mileConversion];
                [distancesDict setValue:orderID forKey:distanceID];
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
            sortedEateries = searchResults;
        }

    }
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self loadLocations];
    searchResults = allItems;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
    
    // give view title, initialize
    self.title = @"Open Now!";
    //[self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(callAfterTwoSeconds:) userInfo: nil repeats: YES];
    self.tableView.rowHeight = 61;

}

-(void)callAfterTwoSeconds: (NSTimer *) t {
    int timerCount = 0;
    if(timerCount <= 4){
        [self loadLocations];
        [self.tableView reloadData];
        timerCount++;
    }
    else {
        [myTimer invalidate];
        myTimer = nil;
        NSLog(@"Done with Timer");
    }
}

- (void)locationUpdate:(CLLocation *)location {
	self.currentLocation = location;
    NSLog(@"%@", self.currentLocation);
}

- (void)locationError:(NSError *)error {
    NSString *errorMessage = [error description];
	NSLog(@"%@", errorMessage);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

EateryDoc *resultEatery;
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // check if there are contents in the search bar
    if(searchText.length == 0) {
        searchTextEntered = NO;
    }
    // if user inputs text
    else {
        searchTextEntered = YES;
        searchResults = [[NSMutableArray alloc]init];
        
        int eateryCount = [sortedEateries count];
        // checks each eatery, one by one, for search criteria, adds matches to array searchResults
        for (int i = 0; i < eateryCount; i++) {
            resultEatery = [sortedEateries objectAtIndex:i];
            NSString *title = resultEatery.data.title;
            NSString *foodtype = resultEatery.data.foodType;
            NSString *description = resultEatery.data.description;
            NSString *open;
            
            if (resultEatery.data.isItOpen == NO){
                open = @"closed";
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
        [self loadLocations];
    }
    // reloads table with searchResults
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // ... in searchResults
    if (searchTextEntered == YES){
        return [searchResults count];
    }
    // ... in total
    else {
        return [sortedEateries count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"OpenNowCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"OpenNowCell"];
    }
    if (searchTextEntered == NO) {
        EateryDoc *eatery = [sortedEateries objectAtIndex:indexPath.row];
        cell.detailTextLabel.font = [UIFont fontWithName:@"American Typewriter" size:16];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:249 green:249 blue:249 alpha:1];
        cell.textLabel.font = [UIFont fontWithName:@"American Typewriter" size:20];
        cell.textLabel.textColor = [UIColor colorWithRed:.95 green:.95 blue:.95 alpha:1];
        cell.textLabel.shadowColor = [UIColor blackColor];
        cell.textLabel.shadowOffset = CGSizeMake(0,-1);
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
            cell.detailTextLabel.text = distanceString;
            
        }
    }
    else {
        EateryDoc *eatery = [sortedEateries objectAtIndex:indexPath.row];
        cell.textLabel.text = eatery.data.title;
        cell.imageView.image = eatery.thumbImage;
        CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
        if(eateryLocation){
            CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
            double mileConversion = distance * 0.000621371192;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.maximumFractionDigits = 1;
            NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
            NSString *distanceString = [NSString stringWithFormat:@"%@ mi", [distanceFromEatery stringValue]];
            cell.detailTextLabel.text = distanceString;
    }
    // set's background image of table
    // self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
    NSLog(@"tableview: %@", [self.eateries objectAtIndex:indexPath.row]);
}
    return cell;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    allItems = [[NSMutableArray alloc]initWithArray:_eateries];
    //searchResults = allItems;
    // if pickforme (tag 1000) is clicked, picks a random eatery, checks if it's open and displays the detail view
    if([sender tag] == 1002){
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
        while (eatery.data.isItOpen == NO && count <= [_eateries count]);
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
        // hides keyboard
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
@end

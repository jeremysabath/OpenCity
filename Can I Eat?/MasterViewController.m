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

@interface MasterViewController () {
    NSMutableArray *_objects;
    
    // create array of all eateries, just search results and bool for if search text was entered
    NSMutableArray *allItems;
    NSMutableArray *searchResults;
    BOOL searchTextEntered;
    
    NSTimer *myTimer;
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



// Stackmob
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locationController = [[MyCLController alloc] init];
	locationController.delegate = self;
	[locationController.locationManager startUpdatingLocation];
    
    // give view title, initialize 
    self.title = @"WhereTo?";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    // Stackmob
    self.managedObjectContext = [self.appDelegate managedObjectContext];
    
    // fill array with all eateries
    allItems = [[NSMutableArray alloc]initWithArray:_eateries];
    searchResults = allItems;
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(callAfterTwoSeconds:) userInfo: nil repeats: YES];
}

int timerCount = 0;
-(void)callAfterTwoSeconds: (NSTimer *) t {
    if(timerCount <= 4){
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
    // check if there are contents in the search bar
    if(searchText.length == 0) {
        searchTextEntered = NO;
    }
    // if user inputs text
    else {
        searchTextEntered = YES;
        searchResults = [[NSMutableArray alloc]init];

        int eateryCount = [allItems count];
        // checks each eatery, one by one, for search criteria, adds matches to array searchResults
        for (int i = 0; i < eateryCount; i++) {
            resultEatery = [allItems objectAtIndex:i];
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
    }
    // reloads table with searchResults
    [self.tableView reloadData];
}

-(void)reloadForLocation {
    int eateryCount = [allItems count];
    for (int i = 0; i < eateryCount; i++) {
        resultEatery = [allItems objectAtIndex:i];
        [searchResults addObject:resultEatery];
    }
    [self.tableView reloadData];
}

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
    int eateryCount = [allItems count];
    searchResults = [[NSMutableArray alloc]init];
    // checks each eatery, one by one, for search criteria, adds matches to array searchResults
    for (int i = 0; i < eateryCount; i++) {
        searchTextEntered = YES;
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
    // reloads table with searchResults
    [self.tableView reloadData];
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
    // ... in searchResults
    if (searchTextEntered == YES){
        return [searchResults count];
    }
    // ... in total
    else {
        return [allItems count];
    }
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
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyBasicCell" forIndexPath:indexPath];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica Bold" size:17];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyBasicCell"];
    }
    if (searchTextEntered == NO) {
        EateryDoc *eatery = [allItems objectAtIndex:indexPath.row];
        cell.textLabel.text = eatery.data.title;
        cell.imageView.image = eatery.thumbImage;
        CLLocation *eateryLocation = [[CLLocation alloc] initWithLatitude:eatery.data.latitude longitude:eatery.data.longitude];
        if(eateryLocation){
            CLLocationDistance distance = [self.currentLocation distanceFromLocation:eateryLocation];
            double mileConversion = distance * 0.000621371192;
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            formatter.maximumFractionDigits = 1;
            NSNumber *distanceFromEatery = [formatter numberFromString:[formatter stringFromNumber:[NSNumber numberWithDouble:mileConversion]]];
            cell.detailTextLabel.text = [distanceFromEatery stringValue];
        }
    }
    else {
        EateryDoc *eatery = [searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = eatery.data.title;
        cell.imageView.image = eatery.thumbImage;
        //cell.detailTextLabel.text = [distanceFromEatery stringValue];
    }
    // set's background image of table
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.jpg"]];
        NSLog(@"tableview: %@", [self.eateries objectAtIndex:indexPath.row]);
        return cell;
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
    // loadData experiment
    AppDelegate *delegate = [[AppDelegate alloc]init];
    [delegate loadData];
    
    allItems = [[NSMutableArray alloc]initWithArray:_eateries];
    //searchResults = allItems;
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
        // hides keyboard
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
        
        // loadData experiment
        NSLog(@"Al's isItOpen = %i", eatery.data.isItOpen);
        NSLog(@"Al's closesAt = %f", eatery.data.closesAt);
        
        // hides keyboard
        [self.searchBar resignFirstResponder];

    }
}
@end

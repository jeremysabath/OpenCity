//
//  DetailViewController.m
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import "DetailViewController.h"
#import "EateryData.h"
#import "EateryDoc.h"
#import "AppDelegate.h"
#import "MasterViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

// synthesize properties
@synthesize picker = _picker;
@synthesize titleField = _titleField;
@synthesize imageView = _imageView;
@synthesize rateView = _rateView;
@synthesize descriptionView = _descriptionView;

/**************
 Much of the isItOpenClicked method is very repetitive with only marginal changes to account for nuances 
 in the schedules of various eateries. After the first fiew alerts, you probably don't have to read the
 rest too closely. As such, my specific comments are in the first few. 
 ***************/

// if the is it open button is clicked....
- (IBAction)isItOpenClicked:(id)sender {
    
    // loadData experiment
    NSLog(@"isItOpen = %i", self.detailItem.data.isItOpen);
    
    // get the current time
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH.mm.ss"];
    NSString *stringTime = [formatter stringFromDate:[NSDate date]];
    // convert time from string to float
    float time = [stringTime floatValue];
    
    // Error checking for programmer, prints opensAt and closesAt data for current eatery as well as current time
    NSLog(@"%f", time);
    NSLog(@"open = %f and close = %f", self.detailItem.data.opensAt, self.detailItem.data.closesAt);
    
    // if it's closed on a day
    if (self.detailItem.data.closesAt == 25){
        // declare message alert view will show
        NSString *closesMessage = [NSString stringWithFormat: @"Sorry! Closed all day!"];
        // declare an alert view to alert user
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Is It Open?"
                              message:closesMessage
                              delegate:self
                              cancelButtonTitle:@"Done"
                              otherButtonTitles: nil];
        // show the alert
        [alert show];

    }
    // if it's open 24 hours
    else if (self.detailItem.data.closesAt == 48){
        NSString *closesMessage = [NSString stringWithFormat: @"Yup! Open 24 hours!"];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Is It Open?"
                              message:closesMessage
                              delegate:self
                              cancelButtonTitle:@"Done"
                              otherButtonTitles: @"Take Me There!", nil];
    }
    // if it opens at midnight...
    else if (self.detailItem.data.opensAt == 24) {
        
        // declare string with opening and closing times
        NSString *closes = [NSString stringWithFormat:@"%.2f", self.detailItem.data.closesAt];
        NSString *opens = [NSString stringWithFormat:@"%.2f", self.detailItem.data.opensAt];
        
        // ... and is open
        if (self.detailItem.data.isItOpen == YES) {
            NSString *closesMessage = [NSString stringWithFormat: @"Yup! Open till %@am!", closes];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:closesMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: @"Take Me There!", nil];
            [alert show];
        }
        // ... and will be open
        // if the eatery is closed and the current time is before when the eatery opens
        else if (self.detailItem.data.isItOpen == NO && time < self.detailItem.data.opensAt) {
            NSString *opensMessage = [NSString stringWithFormat: @"Sorry! Opens at 12am!"];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:opensMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
        }
        // ... and is already closed
        else {
        NSString *closesMessage = [NSString stringWithFormat: @"Sorry! Closed at %@am!", closes];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Is It Open?"
                              message:closesMessage
                              delegate:self
                              cancelButtonTitle:@"Done"
                              otherButtonTitles: nil];
        [alert show];
        }
    }
        // if it closes after midnight...
    else if (self.detailItem.data.closesAt <= 4){
        NSString *closes = [NSString stringWithFormat:@"%.2f", self.detailItem.data.closesAt];
        NSString *opens = [NSString stringWithFormat:@"%.2f", self.detailItem.data.opensAt];
        // ... and is open
        if (self.detailItem.data.isItOpen != NO) {
            NSString *closesMessage = [NSString stringWithFormat: @"Yup! Open till %@am!", closes];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:closesMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: @"Take Me There!", nil];
            [alert show];
        }        
        // ... and will open before noon
        // if eatery is closed and current time is before eatery opens and eatery opens before noon
        else if (self.detailItem.data.isItOpen == NO && time < self.detailItem.data.opensAt && self.detailItem.data.opensAt < 12) {
            NSString *opensMessage = [NSString stringWithFormat: @"Sorry! Opens at %@am!", opens];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:opensMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
        }
        // ... and will open after noon
        // if eatery is closed and current time is before eatery opens and eatery opens after noon
        else if (self.detailItem.data.isItOpen == NO && time < self.detailItem.data.opensAt && self.detailItem.data.opensAt >= 12) {
            opens = [NSString stringWithFormat:@"%.2f", self.detailItem.data.opensAt-12];
            NSString *opensMessage = [NSString stringWithFormat: @"Sorry! Opens at %@pm!", opens];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:opensMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
        }
        // ...and is already closed
        else {
            NSString *closesMessage = [NSString stringWithFormat: @"Sorry! Closed at %@am!", closes];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:closesMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
            }
    }
    // if it closes at midnight...
    else if (self.detailItem.data.closesAt == 24) {
        NSString *closes = [NSString stringWithFormat:@"%.2f", self.detailItem.data.closesAt];
        NSString *opens = [NSString stringWithFormat:@"%.2f", self.detailItem.data.opensAt];
        // ..and is open
        if (self.detailItem.data.isItOpen == YES) {
            NSString *closesMessage = [NSString stringWithFormat: @"Yup! Open till midnight!"];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:closesMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: @"Take Me There!", nil];
            
            [alert show];
        }
        // ... and will open before noon
        else if (self.detailItem.data.isItOpen == NO && time < self.detailItem.data.opensAt && self.detailItem.data.opensAt < 12) {
            NSString *opensMessage = [NSString stringWithFormat: @"Sorry! Opens at %@am!", opens];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:opensMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
        }
        // ... and wil open after noon
        else if (self.detailItem.data.isItOpen == NO && time < self.detailItem.data.opensAt && self.detailItem.data.opensAt >= 12) {
            opens = [NSString stringWithFormat:@"%.2f", self.detailItem.data.opensAt-12];
            NSString *opensMessage = [NSString stringWithFormat: @"Sorry! Opens at %@pm!", opens];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:opensMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
        }
        // ...and is already closed
        else {
            NSString *closesMessage = [NSString stringWithFormat: @"Sorry! Closed at midnight!"];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:closesMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
        }

    }
    // if it closes before midnight...
    else{
        NSString *closes = [NSString stringWithFormat:@"%.2f", self.detailItem.data.closesAt-12];
        NSString *opens = [NSString stringWithFormat:@"%.2f", self.detailItem.data.opensAt];
        // ... and is open
        if (self.detailItem.data.isItOpen == YES) {
            NSString *closesMessage = [NSString stringWithFormat: @"Yup! Open till %@pm!", closes];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:closesMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: @"Take Me There!", nil];
            [alert show];
        }
        // ... and will open before noon
        else if (self.detailItem.data.isItOpen == NO && time < self.detailItem.data.opensAt && self.detailItem.data.opensAt < 12) {
            NSString *opensMessage = [NSString stringWithFormat: @"Sorry! Opens at %@am!", opens];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:opensMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
        }
        // ... and wil open after noon
        else if (self.detailItem.data.isItOpen == NO && time < self.detailItem.data.opensAt && self.detailItem.data.opensAt >= 12) {
            opens = [NSString stringWithFormat:@"%.2f", self.detailItem.data.opensAt-12];
            NSString *opensMessage = [NSString stringWithFormat: @"Sorry! Opens at %@pm!", opens];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:opensMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
        }
        // ... and is closed
        else {
            NSString *closesMessage = [NSString stringWithFormat: @"Sorry! Closed at %@pm!", closes];
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Is It Open?"
                                  message:closesMessage
                                  delegate:self
                                  cancelButtonTitle:@"Done"
                                  otherButtonTitles: nil];
            [alert show];
            
        }
    }

}

// if user clicks the Take me there button from the alert view, get the address of the eatery and
// open it in the maps application
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
if(buttonIndex == 1){
    // obtain eatery address
    NSString *address = self.detailItem.data.address;
    address = [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *urlText = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", address];
    NSLog(urlText);
    // open maps
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

// manage the star-rating view
- (void)configureView
{
    // Update the user interface for the detail item.
    // Create properties for the rateView
    self.rateView.notSelectedImage = [UIImage imageNamed:@"EmptyStar.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"Star.png"];
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    
    // set correct GUI
    if (self.detailItem) {
        self.titleField.text = self.detailItem.data.title;
        self.rateView.rating = self.detailItem.data.rating;
        self.imageView.image = self.detailItem.fullImage;
        self.descriptionView.text = self.detailItem.data.description;
    }
}

// Apple Housekeeping
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

// Apple Housekeeping
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
// allows user to change picture
- (IBAction)addPictureTapped:(id)sender {
    if (self.picker == nil) {
        self.picker = [[UIImagePickerController alloc]init];
        self.picker.delegate = self;
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.picker.allowsEditing = NO;
    }
    [self.navigationController presentViewController:_picker animated:YES completion:NULL];
}

// if user taps the Let's Go button, obtains address of eatery and opens it in maps
- (IBAction)linkToMaps:(id)sender{
    // obtains address
    NSString *address = self.detailItem.data.address;
    address = [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *urlText = [NSString stringWithFormat:@"http://maps.apple.com/?q=%@", address];
    // opens it in maps
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlText]];
}

// if user taps Call Now button, obtains eatery phone number and calls it
- (IBAction)callNowClicked:(id)sender{
    // if the eatery has no phone number, apologize with an alert
    if (self.detailItem.data.number == @"NONE"){
        NSString *message = [NSString stringWithFormat:@"Sorry! %@ has no phone number!", self.detailItem.data.title];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oops!"
                              message:message
                              delegate:self
                              cancelButtonTitle:@"Done"
                              otherButtonTitles: nil];
        [alert show];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.detailItem.data.number]];
}

// if user taps website button, obtains eatery website and opens in safari
- (IBAction)websiteClicked:(id)sender{
    NSURL *url = [[ NSURL alloc] initWithString:self.detailItem.data.website];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark RateViewDelegate

// when user changes rating, change rating
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    self.detailItem.data.rating = rating;
}


@end

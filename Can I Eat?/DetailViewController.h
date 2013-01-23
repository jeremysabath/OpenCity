//
//  DetailViewController.h
//  Can I Eat?
//
//  Created by Jeremy Sabath on 12/1/12.
//  Copyright (c) 2012 Jeremy Sabath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@class EateryDoc;

@interface DetailViewController : UIViewController <UITextFieldDelegate, RateViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    // declares a ui button
    UIButton *button;
}

// setter and getter methods, declares properties of the detail view
@property (strong, nonatomic) EateryDoc *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet RateView *rateView;
@property (strong, nonatomic) UIImagePickerController * picker;
@property (strong, nonatomic) IBOutlet UILabel *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *openNowLabel;
@property (weak, nonatomic) IBOutlet UIImageView *openNowDot;


// declares methods/connections with the view
- (IBAction)isItOpenClicked:(id)sender;
- (IBAction)linkToMaps:(id)sender;
- (IBAction)callNowClicked:(id)sender;
- (IBAction)websiteClicked:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

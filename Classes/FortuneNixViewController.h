//
//  FortuneNixViewController.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PreferencesViewController.h"
#import "FortuneTeller.h"
#import "FavoriteActionDelegate.h"

#import <iAd/iAd.h>

@protocol ViewControllerDelegate;

@interface FortuneNixViewController : UIViewController <ViewControllerDelegate> {

	IBOutlet UITextView *content;
	IBOutlet UIBarButtonItem *browseButton;
	IBOutlet UIButton *preferencesButton;
	IBOutlet UIBarButtonItem *nextButton;
	IBOutlet UIBarButtonItem *backButton;
	IBOutlet UIToolbar *toolbar;
			
	
	FortuneTeller *fortuneTeller;
	
	FavoriteActionDelegate *favoriteDelegate;
	
	IBOutlet ADBannerView *banner;
	
}

@property (nonatomic, retain) UITextView *content;
@property (nonatomic, retain) FortuneTeller *fortuneTeller;
@property (nonatomic, retain) FavoriteActionDelegate *favoriteDelegate;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;



- (IBAction)viewClicked:(id)sender;

- (IBAction)browsePressed:(id)sender;
- (IBAction)plusPressed:(id)sender;

- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;


- (IBAction)preferencesPressed:(id)sender;


@end

@protocol ViewControllerDelegate
- (void)viewControllerDidFinish:(UIViewController *) contoller;
@end


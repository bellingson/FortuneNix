//
//  FortuneNixViewController.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FortuneNixViewController.h"
#import "PreferencesViewController.h"
#import "BrowseTableViewController.h"

@implementation FortuneNixViewController

@synthesize fortuneTeller, content, favoriteDelegate, banner;

#pragma mark -
#pragma mark Banner View Methods

- (void) moveBannerViewOffScreen {

	CGRect frame = self.content.frame;
	CGFloat newHeight = self.view.frame.size.height;
	CGRect newFrame = frame;
	newFrame.origin.y = 0;
	newFrame.size.height = newHeight;
	
	CGRect newBannerFrame = self.banner.frame;
	//newBannerFrame.origin.y	= newHeight;
	newBannerFrame.origin.y	= 0 - self.banner.frame.size.height;
	
	self.content.frame = newFrame;
	self.banner.frame = newBannerFrame;
	
}

- (void) moveBannerViewOnScreen {
	CGRect newBannerFrame = self.banner.frame;
	newBannerFrame.origin.y = 0;
	CGRect newFrame = self.content.frame;
	newFrame.origin.y = newBannerFrame.size.height;

	newFrame.size.height = self.view.frame.size.height - newBannerFrame.size.height;
	
	[UIView beginAnimations:@"BannerViewIntro" context:NULL];
	self.content.frame = newFrame;
	self.banner.frame = newBannerFrame;
	[UIView commitAnimations];
	
	
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	[self moveBannerViewOffScreen];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
	[self moveBannerViewOnScreen];
}



#pragma mark -
#pragma mark IBActions


- (IBAction)plusPressed:(id)sender {
	
	[favoriteDelegate display];
	
}

- (IBAction)preferencesPressed:(id)sender {
	
//	NSLog(@"preferences pressed");
	
	PreferencesViewController *controller = [[PreferencesViewController alloc] initWithNibName:@"PreferencesView" bundle:nil];

	controller.delegate = self;
	controller.fortuneTeller = fortuneTeller;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller retain];
	
}

- (IBAction)browsePressed:(id)sender {
	
	BrowseTableViewController *controller = [[BrowseTableViewController alloc] initWithNibName:@"BrowseTableViewController" bundle:nil];
	controller.delegate = self;
	controller.fortuneTeller = fortuneTeller;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	
	[controller retain];
	
}

- (IBAction)viewClicked:(id)sender {
		
	BOOL hide = (toolbar.hidden != YES);	
	toolbar.hidden = hide;
	
}

- (IBAction)nextButtonPressed:(id)sender {
	
	[backButton setEnabled: YES];
	
	[self showNextFortune];
}

- (IBAction)backButtonPressed:(id)sender {
	
	[fortuneTeller back];	
	[self displayFortune];
	
	if([fortuneTeller canBrowseBack] == NO) {
		[backButton setEnabled: NO];
	}
}


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


- (void)showNextFortune {
	
	[fortuneTeller next];
	
	[self displayFortune];
	
}

- (void)displayFortune {
	
	//NSLog(@"display fortune: %@",fortuneTeller);

	NSString *formatted = [NSString stringWithFormat:@"%@\n\n%@",fortuneTeller.prompt,fortuneTeller.fortune.content];
	
	content.text = formatted;

} 

#pragma mark -
#pragma mark View Methods

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	self.banner.requiredContentSizeIdentifiers = [NSSet setWithObjects: 
													ADBannerContentSizeIdentifier320x50,
													ADBannerContentSizeIdentifier480x32,
												  nil];
	
	[self moveBannerViewOffScreen];
	
	fortuneTeller = [[FortuneTeller alloc] init];
	
	favoriteDelegate = [[FavoriteActionDelegate alloc] init];
	favoriteDelegate.view = self.view;
	favoriteDelegate.fortuneTeller = fortuneTeller;

	[self showNextFortune];
	
    [super viewDidLoad];
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration: duration];
		
	if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
		banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
	} else {
		banner.currentContentSizeIdentifier = ADBannerContentSizeIdentifier480x32;	
	}	
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)viewControllerDidFinish:(UIViewController *) controller {
		
	[self dismissModalViewControllerAnimated:YES];
	
	[self displayFortune];
	
	[controller release];
}


- (void)dealloc {
	banner.delegate = nil;
	[banner release];
    [super dealloc];
}

@end

//
//  FavoriteActionDelegate.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/18/09.
//  Copyright 2009 Northstar New Media. All rights reserved.
//

#import "FavoriteActionDelegate.h"


@implementation FavoriteActionDelegate


@synthesize view, fortuneTeller;

- (void) display {

	NSString *addRemoveTitle;	
	if (fortuneTeller.fortune.favorite == YES) {
		addRemoveTitle = @"Remove Favorite";
	} else {
		addRemoveTitle = @"Add Favorite";
	}
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil
													otherButtonTitles:addRemoveTitle,@"Email This", @"Cancel", nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	actionSheet.destructiveButtonIndex = 2;	// make the second button red (destructive)
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];

}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	//NSLog(@"action sheet selection: %d",buttonIndex);
		
	switch (buttonIndex) {
		case 0:
						
			if (fortuneTeller.fortune.favorite == YES) {
				[fortuneTeller removeFavorite];
			} else {
				[fortuneTeller addFavorite];
			}	
			
			return;
		case 1:
			[fortuneTeller addFavorite];
			[self emailFavorite];
			return;			
		default:
			break;
	}
		
	
}

- (void)emailFavorite {
	
	
	NSString *uc = [NSString stringWithFormat: @"mailto:?subject=iPhone Fortune&body=%@\n\nSent via FortuneNix iPhone App",fortuneTeller.fortune.content];
	
	NSString *urlString = [uc stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];

//	NSLog(@"send email: foo %@",uc);
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	BOOL open = [[UIApplication sharedApplication] openURL:url];
	
	//NSLog(@"open url: %d",open);
	

	
	
}





@end

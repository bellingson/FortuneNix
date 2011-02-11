//
//  BrowseTableViewController.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FortuneNixViewController.h"


@protocol ViewControllerDelegate;

@interface BrowseTableViewController : UITableViewController {
	
	id <ViewControllerDelegate> delegate;
	
	FortuneTeller *fortuneTeller;
	
}


@property (nonatomic, assign) id <ViewControllerDelegate> delegate; 
@property (nonatomic, assign) FortuneTeller *fortuneTeller;


@end



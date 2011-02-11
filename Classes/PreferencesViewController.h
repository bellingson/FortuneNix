//
//  PreferencesViewController.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FortuneTeller.h"
#import "FortuneNixViewController.h"

@protocol ViewControllerDelegate;

@interface PreferencesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

	id <ViewControllerDelegate> delegate;
	
	IBOutlet UISwitch *offensive;
	IBOutlet UITextField *prompt;
	
	IBOutlet UITableViewCell *cell0;	
    IBOutlet UITableViewCell *cell1;
	IBOutlet UITableViewCell *cell2;
	IBOutlet UITextView *about;
	IBOutlet UITableView *tableView;
	
	FortuneTeller *fortuneTeller;
	
}

@property (nonatomic, assign) id <ViewControllerDelegate> delegate; 
@property (readwrite) FortuneTeller *fortuneTeller;

@property (nonatomic, retain) UISwitch *offensive;
@property (readwrite) UITextField *prompt;

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell0;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell1;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell2;
@property (nonatomic, retain) IBOutlet UITextView *about;

- (IBAction)done;
- (IBAction)promptUpdated;



@end


//
//  PreferencesViewController.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PreferencesViewController.h"


@implementation PreferencesViewController


@synthesize delegate, fortuneTeller, offensive, prompt, tableView, cell0, cell1, cell2, about;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
	
	//NSLog(@"starting view did load: %@", fortuneTeller.prompt );
	
	offensive.on = fortuneTeller.showOffensive;
	prompt.text = fortuneTeller.prompt;
		
	about.font = [UIFont systemFontOfSize: 14.0];
	
}


- (IBAction)done {
		
	fortuneTeller.showOffensive = offensive.on;
	fortuneTeller.prompt = prompt.text;
	
	//NSLog(@"update preferences: %d : %@",fortuneTeller.showOffensive, fortuneTeller.prompt);
	
	if(fortuneTeller.showOffensive == NO && fortuneTeller.category.offensive == YES) {
		
		fortuneTeller.category = [fortuneTeller.categories objectAtIndex:0];
		[fortuneTeller loadFortuneCount];
		fortuneTeller.next;
	}
	
	[fortuneTeller savePrefs];	
	
	[self.delegate viewControllerDidFinish:self];	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//NSLog(@"number of rows: %d",[browseItems count]);
	
    return 1;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  
{  
	 if(indexPath.section == 0 && indexPath.row == 0) {
		 return cell0.bounds.size.height;
	 }
	
	if(indexPath.section == 1 && indexPath.row == 0) {
		return 80.0;
	}

	if(indexPath.section == 2 && indexPath.row == 0) {
		return 200.0;
	}
	
	
     return 80.0; 
}  


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	
	if(indexPath.section == 0 && indexPath.row == 0) {
		return cell0;
	}

	if(indexPath.section == 1 && indexPath.row == 0) {
		return cell1;
	}
	
	if(indexPath.section == 2 && indexPath.row == 0) {
		return cell2;
	}
	
    return nil;
}




/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	NSLog(@"did receive memory warning");
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[fortuneTeller release];
    [super dealloc];
}


@end

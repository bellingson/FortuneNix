//
//  BrowseTableViewController.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BrowseTableViewController.h"

#import "FortuneNixViewController.h"

#import "FortuneCategory.h"

@implementation BrowseTableViewController

@synthesize delegate, fortuneTeller;

NSArray *browseItems;


/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/




- (void)viewDidLoad {
    [super viewDidLoad];

	//NSLog(@"loading Browse View: %d",fortuneTeller.showOffensive);	
	
	if(fortuneTeller.showOffensive == YES) {
		//browseItems = [FortuneCategory allCategories];	
		browseItems = fortuneTeller.categories;
	} else {
		browseItems = [FortuneCategory nonOffensiveCategories];	
	}
	
	//NSLog(@"browse items init: %d",[browseItems count]);
	
	// select the current category??
/*	
	int row = [browseItems indexOfObject: fortuneTeller.category];
	
	NSLog(@"category: %@ : row: %d",fortuneTeller.category.label,row);
	
	NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:0];
	[self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionNone];
	
	[self.tableView reloadData];
 */
	
	[browseItems retain];

}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	//NSLog(@"number of rows: %d",[browseItems count]);
	
    return [browseItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Set up the cell...
	
	FortuneCategory *fc = [browseItems objectAtIndex:indexPath.row];
	
	// add count for favorites
	if (fc.ID == FAVORITE_CATEGORY) {
		cell.text = [NSString stringWithFormat: @"%@ (%d)",fc.label, fortuneTeller.favoriteCount];
	} else {
		cell.text = fc.label;		
	}
	

	
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	FortuneCategory *fc = [browseItems objectAtIndex:indexPath.row];
	
	//NSLog(@"change to browse: %@",fc.label);
	
	fortuneTeller.category = fc;
	[fortuneTeller savePrefs];
	
	[fortuneTeller next];
	
	[self.delegate viewControllerDidFinish:self];
			
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[browseItems release];
    [super dealloc];
}


@end


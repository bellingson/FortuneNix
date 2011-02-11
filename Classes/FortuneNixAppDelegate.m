//
//  FortuneNixAppDelegate.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FortuneNixAppDelegate.h"
#import "FortuneNixViewController.h"

@implementation FortuneNixAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end

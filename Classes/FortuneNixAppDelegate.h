//
//  FortuneNixAppDelegate.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/14/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FortuneNixViewController;

@interface FortuneNixAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FortuneNixViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FortuneNixViewController *viewController;

- (IBAction)windowTapped:(id)sender;

@end


//
//  FavoriteActionDelegate.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/18/09.
//  Copyright 2009 Northstar New Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FortuneTeller.h"

@interface FavoriteActionDelegate : NSObject <UIActionSheetDelegate> {

	UIView *view;
		
	FortuneTeller *fortuneTeller;
	
}

@property (readwrite,retain) UIView	*view;
@property (readwrite,retain) FortuneTeller *fortuneTeller;

- (void) display;

@end

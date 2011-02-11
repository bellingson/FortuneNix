//
//  FortuneWindow.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FortuneWindow.h"
#import "FortuneTextView.h"


@implementation FortuneWindow


-(void)sendEvent:(UIEvent *)event {
	//loop over touches for this event
	for(UITouch *touch in [event allTouches]) {
		BOOL touchEnded = (touch.phase == UITouchPhaseEnded);
		BOOL isSingleTap = (touch.tapCount == 1);
		BOOL isHittingCustomTextView = 
		(touch.view.class == [FortuneTextView class]);
		
		if(touchEnded && isSingleTap && isHittingCustomTextView) {
			
			//NSLog(@"send event");
			
			FortuneTextView *tv = (FortuneTextView*)touch.view;
			[tv tapOccurred:event];
		}
	}
	
	[super sendEvent:event];
	
	
}


@end

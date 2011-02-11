//
//  FortuneTextView.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FortuneTextView.h"


@implementation FortuneTextView

-(void)tapOccurred:(UIEvent *) event {
	
	//NSLog(@"tap occurred: %@",self.delegate);
	
	[self.delegate viewClicked: self];
	
}

@end

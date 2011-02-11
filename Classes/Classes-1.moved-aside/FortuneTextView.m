//
//  FortuneTextView.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FortuneTextView.h"


@implementation FortuneTextView


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesEnded FOOF - touch count = %d", [touches count]);
    for(UITouch *touch in event.allTouches) {
        //[self logTouchInfo:touch];
    }
}

@end

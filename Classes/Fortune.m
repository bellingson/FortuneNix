//
//  Fortune.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Fortune.h"


@implementation Fortune

@synthesize itemId, content, type, offensive, favorite;


#pragma mark Fortune type methods


+ (int) type: (NSString *) typeString {

	NSArray *ta = [Fortune typesArray];
	for(int i=0;i<=[ta count];i++) {
		int n = [[ta objectAtIndex:i] intValue];
		NSString *ts = [Fortune typeString:n];

		if([typeString isEqualToString: ts]) {
			return n;
		}
	}
		
	return -1;
}

+ (NSString *)typeString: (int) type {

	switch (type) {
		case FORTUNE_TYPE:
			return @"Fortune";
		case STAR_TREK_TYPE:
			return @"Star Trek";
		case LIMERICK_TYPE:
			return @"Limerick";
		case MURPHY_TYPE:
			return @"Murphey";
		case ZIPPY_TYPE:
			return @"Zippy";
		case OFFENSIVE_TYPE:
			return @"Offensive";
		default:
			break;
	}
	return @"Fortune";
}

+ (NSArray *)typesArray 
{
		
	NSArray *ta = [NSArray arrayWithObjects: [NSNumber numberWithInt:FORTUNE_TYPE],
									[NSNumber numberWithInt:STAR_TREK_TYPE],
									[NSNumber numberWithInt:LIMERICK_TYPE],
									[NSNumber numberWithInt:MURPHY_TYPE],
									[NSNumber numberWithInt:ZIPPY_TYPE],
									[NSNumber numberWithInt:OFFENSIVE_TYPE], 
									nil ];
	
	return ta;
	
}


- (NSString *)typeString  {
	return [Fortune typeString: type];	
}


- (void) dealloc 
{
	[content release];
	[super dealloc];
}


@end

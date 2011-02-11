//
//  Fortune.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FORTUNE_TYPE 1
#define STAR_TREK_TYPE 2
#define LIMERICK_TYPE 3
#define MURPHY_TYPE 4
#define ZIPPY_TYPE 5
#define OFFENSIVE_TYPE 6

@interface Fortune : NSObject {
	
	int itemId;
	NSString *content;
	int type;
	BOOL offensive;	
	BOOL favorite;
		
}

+ (NSArray *)typesArray;
+ (int) type: (NSString *) typeString;
+ (NSString *)typeString: (int) type;
- (NSString *)typeString;

@property (readwrite) int itemId;
@property (readwrite, retain) NSString *content;
@property (readwrite) int type;
@property (readwrite) BOOL offensive;
@property (readwrite) BOOL favorite;

@end

//
//  FortuneCategory.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_CATEGORY 0
#define FAVORITE_CATEGORY 2


@interface FortuneCategory : NSObject {
	
	int ID;
	int type;
	NSString *label;
	BOOL offensive;
	NSString *criteria;
	
}

@property (readwrite) int ID;
@property (readwrite) int type;
@property (readwrite, retain) NSString *label;
@property (readwrite) BOOL offensive;
@property (readwrite, retain) NSString *criteria;

+ (NSArray *)nonOffensiveCategories;
+ (NSArray *)allCategories;

+ (FortuneCategory *) create:(int)aID type:(int)aType label:(NSString *)aLabel offensive:(BOOL)aOffensive criteria:(NSString *)aCriteria;

@end

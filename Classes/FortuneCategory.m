//
//  FortuneCategory.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FortuneCategory.h"
#import "Fortune.h"


@implementation FortuneCategory


@synthesize ID, type, offensive, label, criteria;

+ (FortuneCategory *) create: (int) aID type: (int) aType label: (NSString *) aLabel offensive: (BOOL) aOffensive criteria: (NSString *) aCriteria {
	FortuneCategory *fc = [[FortuneCategory alloc]init];
	fc.ID = aID;
	fc.type = aType;
	fc.label = aLabel;
	fc.offensive = aOffensive;
	fc.criteria = aCriteria;
	
	return fc;
}

+ (NSArray *)nonOffensiveCategories {
	
	NSArray *all = [FortuneCategory allCategories];
	
	NSMutableArray *r = [NSMutableArray arrayWithArray: all];
	
	int c = [all count];
	for(int i =0;i<c;i++) {
		FortuneCategory *fc = [all objectAtIndex:i];
		if (fc.offensive == YES) {
			[r removeObject: fc];
		}
	}
	
	return r;
}

+ (NSArray *)allCategories {
	
	NSArray *r = [NSArray arrayWithObjects: 
						[FortuneCategory create:0 type:1 label: @"Fortune" offensive: NO 
									   criteria: [NSString stringWithFormat: @"where f.type = %d and f.offensive = 0",FORTUNE_TYPE]],
						[FortuneCategory create:1  type: 1 label: @"Fortune (offensive)" offensive: YES
									   criteria: [NSString stringWithFormat: @"where f.type = %d and f.offensive = 1",FORTUNE_TYPE]],
						[FortuneCategory create:FAVORITE_CATEGORY type: -1 label: @"Favorites" offensive: NO
									   criteria:  @"where f.id in (select favoriteId from favorites) " ], // update
						[FortuneCategory create:3 type: 3 label: @"Limerick (offensive)" offensive: YES
									   criteria: [NSString stringWithFormat: @"where f.type = %d ",LIMERICK_TYPE]],
						[FortuneCategory create:4 type: 4 label: @"Murpy's Law" offensive: NO
									   criteria: [NSString stringWithFormat: @"where f.type = %d and f.offensive = 0",MURPHY_TYPE]],
						[FortuneCategory create:5 type: 4 label: @"Murpy's Law (offensive)" offensive: YES
									   criteria: [NSString stringWithFormat: @"where f.type = %d and f.offensive = 1",MURPHY_TYPE]],
						[FortuneCategory create:6 type: 2 label: @"Star Trek" offensive: NO
									   criteria: [NSString stringWithFormat: @"where f.type = %d and f.offensive = 0",STAR_TREK_TYPE]],
						[FortuneCategory create:7 type: 5 label: @"Zippy the Pinhead" offensive: NO
									   criteria: [NSString stringWithFormat: @"where f.type = %d and f.offensive = 0",ZIPPY_TYPE]],
				  		[FortuneCategory create:8 type: -1 label: @"All Categories" offensive: NO
										criteria: @"where f.offensive = 0"],
						[FortuneCategory create:9 type: -1 label: @"All Categories (offensive)" offensive: YES
										criteria: @"where f.offensive = 1"],
						nil
				  ];
	
	return r;
}

@end

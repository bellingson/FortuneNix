//
//  FortuneTeller.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Fortune.h"
#import "FortuneCategory.h"
#import "DataAccessObject.h"

#define PREF_OFFENSIVE @"offensive"
#define PREF_PROMPT @"prompt"

@interface FortuneTeller : NSObject {

	
	Fortune *fortune;	
	FortuneCategory *category;	
	NSArray *categories;

	int fortuneCount;
	int favoriteCount;
	NSMutableArray *history;
	int historyIndex;
	int favoriteIndex;
	
	BOOL showOffensive;	
	NSString *prompt;
			
	NSString *documentsDirectory;
	NSString *prefsFilePath; 

	DataAccessObject *dao;
	
}

@property (readwrite,retain) Fortune *fortune;
@property (readwrite,retain) FortuneCategory *category;
@property (readwrite,retain) NSArray *categories;

@property (readwrite) BOOL showOffensive;
@property (readwrite,retain) NSString *prompt;

@property (readwrite) int fortuneCount;
@property (readwrite) int favoriteCount;
@property (readwrite,retain) NSMutableArray *history;
@property (readwrite) int historyIndex;
@property (readwrite) int favoriteIndex;

@property (readwrite,retain) NSString *documentsDirectory;
@property (readwrite,retain) NSString *prefsFilePath;
@property (readwrite,retain) DataAccessObject *dao;


- (void)next;
- (void)back;
- (BOOL)canBrowseBack;

- (void)savePrefs;
- (void)addFavorite;
- (void)removeFavorite;

@end

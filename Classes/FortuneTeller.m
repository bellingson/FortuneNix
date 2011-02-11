//
//  FortuneTeller.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#include <stdlib.h>

#import "Fortune.h"
#import "FortuneTeller.h"
#import "DataAccessObject.h"


@implementation FortuneTeller


@synthesize categories, category, fortune, showOffensive, prompt;
@synthesize fortuneCount,favoriteCount, history, historyIndex, favoriteIndex;

@synthesize prefsFilePath, documentsDirectory, dao;



- (id)init {
	
	if([super init]) {
		
		//NSLog(@"loading FortuneTeller");
				
		self.documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		
		self.dao = [[DataAccessObject alloc] init];
		
		self.categories = [FortuneCategory allCategories];
		self.category = [categories objectAtIndex: DEFAULT_CATEGORY];
		
		[self loadPrefs];
		
		[self initPrompt];

		[self loadFavoriteCount];
		[self loadFortuneCount];
		self.history = [[NSMutableArray alloc] init];
		self.historyIndex = -1;
		self.favoriteIndex = 0;
		
		self.fortune = [[Fortune alloc] init];
		
	//	NSLog(@"loading FortuneTeller complete");
		
		
	}
	
	return self;
	
	
}

- (Fortune *) nothingFound {
	//NSLog(@"can't fetch: fortuneCount == 0");
	Fortune *result = [[Fortune alloc] init];
	if (category.ID == 2) {
		result.content = @"you have no favorites";	
	} else {
		result.content = @"error: no data found";
	}
	
	fortune = result;
	return result;
}



- (void)next {
	
	//NSLog(@"next: historyIndex: %d historyCount: %d",historyIndex,[history count] );
	
	if (category.ID == FAVORITE_CATEGORY) {
		[self nextFromFavorites];
		return;
	}
	
	if (historyIndex > 0) {
		[self nextFromHistory];
		return;
	}
	
	[self nextFromRandom];
	

	
}

-(void)nextFromRandom 
{
	
	//NSLog(@"next from random: %d",historyIndex);
	//NSLog(@"history size: %d",[history count]);
	
	if(fortuneCount == 0) {
		fortune = [self nothingFound];
		return;
	}
	
	int r =  rand() % fortuneCount;
	
	NSMutableString *query = [NSMutableString stringWithString:  @"select id, content, type, offensive, favorite from fortune f "];
	[query appendString: category.criteria];				
	[query appendFormat: @" limit 1 offset %d", r];
	
	[dao queryFortune: query fortune: fortune];
	
	[history insertObject:  [NSNumber numberWithInt: fortune.itemId] atIndex: 0 ];
	
	if([history count] >= 50) {
		[history removeObjectAtIndex: 49];
	}
	
	historyIndex = 0;
	
}

-(void)nextFromFavorites 
{
		
	if (favoriteIndex >= favoriteCount) {
		favoriteIndex = 0;
	}
	
	if (favoriteIndex < 0) {
		favoriteIndex = favoriteCount - 1;
	}
	
	//NSLog(@"next from favorites: %d : %d",favoriteIndex,favoriteCount);
	
	NSString *query = [NSString stringWithFormat:@"select * from fortune f where f.id in (select favoriteId from favorites) limit 1 offset %d",favoriteIndex];
	
	[dao queryFortune:query fortune: fortune];
		
	favoriteIndex++;
	
}

-(void)backFromFavorites
{
	favoriteIndex = favoriteIndex - 2;
	[self nextFromFavorites];
	
}


-(void)nextFromHistory 
{
	//NSLog(@"next from history: %d",historyIndex);
		
	historyIndex--;
	
	//NSLog(@"doing next from history: %d of %d",historyIndex,[history count]);
	
	int itemId = [[history objectAtIndex:historyIndex] intValue];
	
	[self queryFortuneById: itemId fortune: fortune];
	
	
}



-(void) back 
{
	//NSLog(@"back");	
		
	if (category.ID == FAVORITE_CATEGORY) {
		[self backFromFavorites];
		return;
	}
	
	[self backFromHistory];	
}

-(BOOL)canBrowseBack {
	
	if (category.ID == FAVORITE_CATEGORY) {
		return YES;
	}
	
	int historyCount = [history count];
	if(historyCount == 0 || historyIndex >= historyCount) {
		//NSLog(@"can't browse back");
		return NO;
	} else {
		return YES;
	}
}


- (void) backFromHistory {

	historyIndex++;	
	
	if([self canBrowseBack] == NO) return;
	
	if(historyIndex < 0) {
		historyIndex = 0;
	}
	
	//NSLog(@"doing back: %d of %d",historyIndex, [history count]);
	
	int itemId = [[history objectAtIndex: historyIndex] intValue];
	
	//NSLog(@"fortune by id: %d",itemId);
	
	[self queryFortuneById: itemId fortune: self.fortune];
	
	//NSLog(@"got fortune by id: %d: %@",itemId,self.fortune);
	
	//historyIndex++;
	
	
}



- (void) queryFortuneById: (int) itemId fortune: (Fortune *) fortune {
	
	NSString *query = [NSString stringWithFormat:  @"select id, content, type, offensive, favorite from fortune f where f.id = %d", itemId];
	
	return [dao queryFortune:query fortune: fortune];
}



- (void)loadFortuneCount 
{


	// initialize random number generator
	srand((unsigned)(time(0))); 
	
	NSMutableString	*query = [NSMutableString stringWithString: @"select count(*) from fortune f " ];
	[query appendString: category.criteria];
	
	fortuneCount = [dao queryCount: query];
	
	//NSLog(@"load fortune count: %d",fortuneCount);
	
}

- (void)loadFavoriteCount 
{
	
	NSString *query = @"select count(*) from favorites f ";
	
	favoriteCount = [dao queryCount: query];
			
	//NSLog(@"favorite count is: %d",favoriteCount);
	
}



- (void)removeFavorite {
	
	//NSLog(@"remove favorite: %d : count %d",fortune.itemId, favoriteCount);
	
	NSMutableString	*query = [NSMutableString stringWithFormat: @"delete from favorites where favoriteId = %d",fortune.itemId ];
	
	[dao executeUpdate: query];
	
	[self loadFavoriteCount];
	[self loadFortuneCount];
	
	fortune.favorite = NO;
	
	//NSLog(@"remove favorite complete: count %d",favoriteCount);
	
}

- (void)addFavorite {
	
	//NSLog(@"fortune teller add favorite");
	
	if(fortune == nil || fortune.itemId == 0 ) {
		//NSLog(@"can't favorite this one");
		return;
	}
	
	NSString *query = [NSString stringWithFormat: @"insert into favorites (favoriteId) values(%d) ",fortune.itemId ];
	
	[dao executeUpdate: query];
	
	query = [NSString stringWithFormat: @"update fortune set favorite = 1 where id = %d",fortune.itemId ];
	
	[dao executeUpdate: query];
	
	fortune.favorite = YES;
	
	[self loadFavoriteCount];
	[self loadFortuneCount];
	 
}

- (void) initPrefsFilePath { 

	prefsFilePath = [documentsDirectory stringByAppendingPathComponent: @"FortuneNix_preferences.plist"]; 
	
	//NSLog(@"Prefs File: %@",prefsFilePath);
	
	[prefsFilePath retain]; 
} 


- (void) loadPrefs { 
		
	//NSLog(@"Load prefs FT: ");
	
	NSMutableDictionary *prefs;
		
	if (prefsFilePath == nil) 
		[self initPrefsFilePath]; 
	if ([[NSFileManager defaultManager] fileExistsAtPath: prefsFilePath]) { 
		prefs = [[NSMutableDictionary alloc] 
				 initWithContentsOfFile: prefsFilePath]; 
	
	} else {
		prefs = [[NSMutableDictionary alloc] init];
	}
	
	[self readPrefs: prefs];
			
}

- (void) readPrefs: (NSMutableDictionary *) prefs {
	
	prompt = [prefs objectForKey: PREF_PROMPT];
	
	showOffensive = [[prefs objectForKey:PREF_OFFENSIVE] boolValue];
			
}

- (void) savePrefs {
	
	[self loadFortuneCount];
	
	//NSLog(@"save prefs: %d: %d: %@ : %@",category.ID,showOffensive,prompt,prefsFilePath);
	
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] init];
	
	[prefs setObject: [NSNumber numberWithBool:showOffensive] forKey:PREF_OFFENSIVE];
	[prefs setObject: prompt forKey:PREF_PROMPT];
	
	[prefs writeToFile: prefsFilePath atomically: YES]; 

}

- (void)initPrompt {
	
	if(prompt == nil) {
		prompt = @"root# fortune";
	}
	
}

- (void)dealloc {
	[fortune release];
	[dao release];
    [super dealloc];
}


@end

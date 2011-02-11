//
//  DataAccessObject.m
//  FortuneNix
//
//  Created by Ben Ellingson on 11/19/09.
//  Copyright 2009 Northstar New Media. All rights reserved.
//

#import "DataAccessObject.h"

#import "sqlite3.h"
#import "Fortune.h"


@implementation DataAccessObject

@synthesize documentsDirectory, databaseFile;

- (id)init {
	
	if([super init]) {
		
		//NSLog(@"loading data access object");
		
		self.documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
		
		[self initDatabase];
		
	}
	
	return self;
}

- (void)initDatabase {
	
	self.databaseFile = [documentsDirectory stringByAppendingPathComponent: @"fortune.db"]; 
	
	//NSLog(@"initializeing database: %@", self.databaseFile);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	if([self shouldCopyDb] == YES) {
		NSString *templateDb = [[NSBundle mainBundle] pathForResource:@"fortune" ofType:@"db"];
		
		NSString *tempDb = [documentsDirectory stringByAppendingPathComponent: @"temp.db"];
		BOOL exists = [fileManager fileExistsAtPath: tempDb];
		if(exists == YES) {
			[fileManager removeItemAtPath: tempDb error:nil];
		}
		
		
		BOOL copyComplete = [fileManager copyItemAtPath: templateDb 
												 toPath: tempDb
												  error: nil];

		if (copyComplete == NO) {
			NSLog(@"ERROR could not copy to temp db");
			return;
		}
		
		[self upgradeDb:tempDb oldDb:self.databaseFile];
		
		[fileManager removeItemAtPath: self.databaseFile error:nil];
		
		copyComplete = [fileManager moveItemAtPath: tempDb 
												 toPath: self.databaseFile
												  error: nil];
		
		NSLog(@"DB COPY: %@ : $d",self.databaseFile, [fileManager fileExistsAtPath: self.databaseFile]);
		
		if (copyComplete == NO) {
			NSLog(@"ERROR could not copy tempDb to prodDb");
		} else {
			NSLog(@"db copy complete: %@",self.databaseFile);
		}
		
		
	}
		
	//NSLog(@"initialized database: %d",self.databaseFile);
}

- (BOOL)upgradeDb: (NSString *) tempDbPath oldDb: (NSString *) oldDbPath {
	
	NSMutableArray *favoriteIds = [[NSMutableArray alloc] init];
	
	NSString *selectFavQ = @"select f.favoriteId from favorites f";
	
	sqlite3 *database;
	if(sqlite3_open([oldDbPath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(database, [selectFavQ UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array			
			
			while(sqlite3_step(stmt) == SQLITE_ROW) {				
				[favoriteIds addObject: [NSNumber numberWithInt: sqlite3_column_int(stmt, 0)]];							
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(stmt);
		sqlite3_close(database);	
	}
	

	for(NSNumber *fortuneId in favoriteIds) {
		
		NSString *updateQ = [NSString stringWithFormat: @"update fortune set favorite = 1 where id = %d",[fortuneId intValue]];

		[self executeUpdateOnDb:updateQ dbPath: tempDbPath];
		
		updateQ = [NSString stringWithFormat: @"insert into favorites (favoriteId) values(%d) ",[fortuneId intValue] ];
		
		[self executeUpdateOnDb:updateQ dbPath: tempDbPath];	
	}
	
	return YES;
}

- (BOOL) shouldCopyDb {
	
	//NSLog(@"db: %@",self.databaseFile);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	BOOL exists = [fileManager fileExistsAtPath: self.databaseFile];
	if(exists == NO) return YES;
	
	NSString *templateDb = [[NSBundle mainBundle] pathForResource:@"fortune" ofType:@"db"];
	
	NSString *templateVersion = [self queryVersion: templateDb];
	NSString *userVersion = [self queryVersion: self.databaseFile];
	
	// set a version to test db upgrade
	//userVersion = @"1.0.0";
	
	//NSLog(@"db version: template: %@ user: %@",templateVersion, userVersion);
	
	int c = [templateVersion compare: userVersion];
	if (c > 0) {
		return YES;
	}
	
	return NO;
}

- (void)buildFortune: (sqlite3_stmt *) stmt fortune: (Fortune *) fortune {
	
	fortune.itemId = sqlite3_column_int(stmt, 0);
	
	const char *content = sqlite3_column_text(stmt,1);				
	
	fortune.content = [NSString stringWithUTF8String: content];
	fortune.type = sqlite3_column_int(stmt, 2);
	fortune.offensive = sqlite3_column_int(stmt, 3);
	fortune.favorite = sqlite3_column_int(stmt, 4);	

}

- (void)queryFortune: (NSString *) query fortune: (Fortune *) fortune {
	
	//NSLog(@"NEXT: db file: %@",databaseFile);
	
	sqlite3 *database;
	if(sqlite3_open([databaseFile UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
						
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array			
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {				
				[self buildFortune: compiledStatement fortune: fortune];								
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		sqlite3_close(database);	
	}
	
}

- (NSString *)queryVersion: (NSString *) dbPath {
	
	NSString *version;
	
	NSString *versionQuery = @"select a.version from app_version a limit 1";
	
	sqlite3 *database;
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		
		sqlite3_stmt *stmt;
		if(sqlite3_prepare_v2(database, [versionQuery UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array			
			
			while(sqlite3_step(stmt) == SQLITE_ROW) {			
			
				const char *v = sqlite3_column_text(stmt,0);	
				version = [NSString stringWithUTF8String: v];
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(stmt);
		sqlite3_close(database);	
	}
	
	return	version;
}


- (int)queryCount: (NSString *) query 
{
	int count = 0;	
	sqlite3 *database;
	if(sqlite3_open([databaseFile UTF8String], &database) == SQLITE_OK) {
		// Setup the SQL Statement and compile it for faster access
		
		//NSLog(@"count query: %@",query);
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				count = sqlite3_column_int(compiledStatement,0);
			}
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
	//NSLog(@"count is: %d",count);
	
	return count;
}

- (void)executeUpdate: (NSString *) query {
	//NSLog(@"executeUpdate: %@ : %@",query,self.databaseFile);
	[self executeUpdateOnDb: query dbPath: self.databaseFile];
}
	
- (void)executeUpdateOnDb: (NSString *) query dbPath: (NSString *) dbPath {
		
	sqlite3 *database;
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
		
		// Setup the SQL Statement and compile it for faster access
		//NSLog(@"executeUpdate: %@",query);
		
		sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
			// execute the update			
			sqlite3_step(compiledStatement);					
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		
	}
	sqlite3_close(database);
	
}




@end

//
//  DataAccessObject.h
//  FortuneNix
//
//  Created by Ben Ellingson on 11/19/09.
//  Copyright 2009 Northstar New Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Fortune.h"


@interface DataAccessObject : NSObject {

	
	NSString *documentsDirectory;
	NSString *databaseFile;	
}

@property (readwrite,retain) NSString *documentsDirectory;
@property (readwrite,retain) NSString *databaseFile;

- (int)queryCount: (NSString *) query;
- (void)queryFortune: (NSString *)query fortune: (Fortune *) fortune;
- (void)executeUpdate: (NSString *) query;
- (NSString *)queryVersion: (NSString *) dbPath;

@end

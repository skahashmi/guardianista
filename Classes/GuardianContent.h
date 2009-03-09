//
//  GuardianContent.h
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"

@interface GuardianContent : SQLitePersistentObject {
	NSInteger contentId;
	NSString *url;
	NSString *type;
	NSString *headline;
	NSString *standfirst;
	NSString *byline;
	NSString *imageUrl;
	NSString *body;
	NSDate *publicationDate;
	NSDictionary *tags;
}

@property (nonatomic) NSInteger contentId;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *headline;
@property (nonatomic, retain) NSString *standfirst;
@property (nonatomic, retain) NSString *byline;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSDate *publicationDate;
@property (nonatomic, retain) NSDictionary *tags;

@end

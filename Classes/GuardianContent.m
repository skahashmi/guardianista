//
//  GuardianContent.m
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "GuardianContent.h"


@implementation GuardianContent
@synthesize contentId;
@synthesize body;
@synthesize url;
@synthesize type;
@synthesize headline;
@synthesize standfirst;
@synthesize byline;
@synthesize imageUrl;
@synthesize publicationDate;
@synthesize tags;

- (void)dealloc {
	[tags release];
	[publicationDate release];
	[imageUrl release];
	[byline release];
	[standfirst release];
	[headline release];
	[type release];
	[url release];
	[super dealloc];
}

@end

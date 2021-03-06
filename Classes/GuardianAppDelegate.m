//
//  GuardianAppDelegate.m
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright Hackdiary Ltd 2009. All rights reserved.
//

#import "GuardianAppDelegate.h"
#import "RootViewController.h"
#import "SQLiteInstanceManager.h"

@implementation GuardianAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize guardian;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
	self.guardian = [[GuardianAPI alloc] init];
	NSArray *searchPaths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0]; 
	
	NSString *dbpath = [documentFolderPath stringByAppendingPathComponent: @"guardian.db"];
	
	[[SQLiteInstanceManager sharedManager] setDatabaseFilepath:dbpath];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[guardian release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end

//
//  GuardianAppDelegate.m
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright Hackdiary Ltd 2009. All rights reserved.
//

#import "GuardianAppDelegate.h"
#import "RootViewController.h"


@implementation GuardianAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize contents;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
	guardian = [[GuardianAPI alloc] init];

	[guardian latestContentWithDelegate:self didSucceedSelector:@selector(content:)];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)content:(NSArray *)content {
	self.contents = content;
	[[((RootViewController *)[navigationController topViewController]) tableView] reloadData];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[self.contents release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end

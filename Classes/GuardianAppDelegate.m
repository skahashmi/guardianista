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
@synthesize guardian;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
	self.guardian = [[GuardianAPI alloc] init];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end

//
//  ContentViewController.m
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "ContentViewController.h"


@implementation ContentViewController
@synthesize url;
/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

	if(self.url) {
		NSLog(@"Here goes: %@", self.url);
		NSLog(@"%@", webView);
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
		[webView loadRequest:request];
	}
}	

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


@end
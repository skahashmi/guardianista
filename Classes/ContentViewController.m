//
//  ContentViewController.m
//  Guardian
//
//  Created by Matt Biddulph on 04/03/2009.
//  Copyright 2009 Hackdiary Ltd. All rights reserved.
//

#import "ContentViewController.h"
#import "TagListViewController.h"

@implementation ContentViewController
@synthesize content;
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

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Tags" style:UIBarButtonItemStylePlain target:self action:@selector(tagButtonWasPressed:)]; 
	self.navigationItem.rightBarButtonItem = button;
	if(self.content) {
		NSLog(@"Here goes: %@", self.content.url);
		NSLog(@"%@", webView);
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.content.url]];
		[webView loadRequest:request];
		self.title = self.content.headline;
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)tagButtonWasPressed:(id)sender {
	TagListViewController *controller = [[TagListViewController alloc]
				  initWithNibName:@"TagListViewController" 
				  bundle:nil]; 	
	[controller setTagData:self.content.tags];
	[self.navigationController pushViewController:controller animated:YES]; 
	[controller release]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[content release];
    [super dealloc];
}


@end
